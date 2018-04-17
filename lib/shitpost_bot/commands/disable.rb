module ShitpostBot
  module Commands
    module Disable
      extend Discordrb::Commands::CommandContainer
      command([:disable, :off],
              description: 'Disables all posting for this/these channel(s).',
              usage: "#{ShitpostBot::BOT.prefix}(disable|off)  [\#channel1 [\#channel2 [...]]]",
              required_permissions: [:manage_server],
              help_available: true
              ) do |event, *channels|
        event.channel.start_typing
        channels = Processing.process_channel_parameters(channels, event.channel)
        return if channels.empty?
        channels.each do |channel|
          checkpoint = channel.checkpoint
          channel.config = ShitpostBot::ChannelConfig.default_settings[:off]
          channel.checkpoint = checkpoint
        end
        event << "All settings have been disabled for #{channels.length == 1 ? 'this channel' : 'these channels'}."
      end
    end
  end
end
