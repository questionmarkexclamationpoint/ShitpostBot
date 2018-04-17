module ShitpostBot
  module Commands
    module Mention
      extend Discordrb::Commands::CommandContainer
      command([:mention, :m], 
              description: 'Enables/disables responses in the channel when the bot is mentioned. If mention is enabled on some/all of the channels given, all given channels will have mention disabled. If replies are also enabled, the bot will *not* double post.',
              usage: "#{BOT.prefix}(mention|m) [\#channel1 [\#channel2 [...]]]",
              required_permissions: [:manage_server],
              help_available: true
              ) do |event, *channels|
        event.channel.start_typing
        channels = Processing.process_channel_parameters(channels, event.channel)
        return if channels.empty?
        turn_on = true
        channels.each do |channel|
          if channel.mention
            turn_on = false 
            break
          end
        end
        channels.each do |channel|
          if turn_on
            unless channel.active
              STATS.active_channels += 1
            end
          elsif channel.mention && channel.reply == 0 && channel.think == 0
            STATS.active_channels -= 1
          end
          channel.mention = turn_on
        end
        event << "Mention has been #{turn_on ? 'enabled' : 'disabled'} for #{channels.length == 1 ? 'this channel' : 'these channels'}."
      end
    end
  end
end
