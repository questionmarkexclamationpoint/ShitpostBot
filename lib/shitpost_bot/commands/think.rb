module ShitpostBot
  module Commands
    module Think
      extend Discordrb::Commands::CommandContainer
      command([:think], 
              description: 'Enables original thoughts on the channel with a given frequency between 0.0 (I won\'t post any original thoughts) and 1.0 (I\'ll post original thoughts constantly). If no frequency is provided, the thought frequency is instead switched between 0.0 and 0.01.',
              usage: "#{BOT.prefix}think [0.0 - 1.0]",
              arg_types: [Float],
              required_permissions: [:manage_server]
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
          elsif channel.think > 0 && !channel.mention && channel.reply == 0
            STATS.active_channels -= 1
          end
          channel.think = frequency
        end
        event << 'Settings updated!'
      end
    end
  end
end
