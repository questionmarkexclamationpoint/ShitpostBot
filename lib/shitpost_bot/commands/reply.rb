module ShitpostBot
  module Commands
    module Reply
      extend Discordrb::Commands::CommandContainer
      command([:reply, :r], 
              description: 'Enables replies on the channel with a given frequency between 0.0 (I won\'t reply to any posts) and 1.0 (I\'ll respond to every post). If no frequency is provided, the reply frequency is instead switched between 0.0 and 1.0.',
              usage: "#{BOT.prefix}reply [0.0 - 1.0]",
              help_available: true,
              required_permissions: [:manage_server],
              arg_types: [Float]
              ) do |event, frequency, *channels|
        event.channel.start_typing
        channels = Processing.process_channel_parameters(channels, event.channel)
        return if channels.empty?
        frequency = frequency.to_f.clamp(0.0, 1.0)
        channels.each do |channel|
          if frequency > 0
            unless channel.active
              STATS.active_channels += 1
            end
          elsif channel.reply > 0 && !channel.mention && channel.think == 0
            STATS.active_channels -= 1
          end
          channel.reply = frequency
        end
        event.channel.send_message('Settings updated!')
      end
    end
  end
end
