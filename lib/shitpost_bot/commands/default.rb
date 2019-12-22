module ShitpostBot
  module Commands
    module Default
      extend Discordrb::Commands::CommandContainer
      command([:default, :d], 
          description: 'Resets posting settings for this channel between the defaults (reply 100% of the time, think 0.1% of the time, respond to mentions) and disabled.',
          usage: "#{ShitpostBot::BOT.prefix}(default|d)  [\#channel1 [\#channel2 [...]]]",
          required_permissions: [:manage_server],
          help_available: true
      ) do |event, *channels|
        event.channel.start_typing
        channels = Processing.process_channel_parameters(channels, event.channel)
        break if channels.empty?
        turn_on = true
        channels.each do |channel|
          unless channel.config == ShitpostBot::ChannelConfig.default_settings[:off]
            turn_on = false
            break
          end
        end
        channels.each do |channel|
          checkpoint = channel.checkpoint
          channel.config = (turn_on ? ShitpostBot::ChannelConfig.default_settings[:on] : channel.config = ShitpostBot::ChannelConfig.default_settings[:off])
          channel.checkpoint = checkpoint
        end
        event << "All settings have been #{turn_on ? 'turned on to their defaults' : 'disabled'} for #{channels.length == 1 ? 'this channel' : 'these channels'}."
      end
    end
  end
end
