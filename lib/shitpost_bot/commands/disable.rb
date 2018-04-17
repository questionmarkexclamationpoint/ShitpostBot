module ShitpostBot
  module Commands
    module Disable
      extend Discordrb::Commands::CommandContainer
      command(:disable, 
              description: 'Disables all posting for this channel.',
              usage: "#{ShitpostBot::BOT.prefix}disable  [\#channel1 [\#channel2 [...]]]",
              required_permissions: [:manage_server]
              ) do |event, *channels|
        event.channel.start_typing
        channels = Processing.process_channel_parameters(channels, event.channel)
        return if channels.empty?
        channels.each do |channel|
          checkpoint = channel.checkpoint
          channel.config = ShitpostBot::ChannelConfig.default_settings[:off]
          channel.checkpoint = checkpoint
        end
        event << "All settings have been #{off ? 'turned on to their defaults' : 'disabled'} for #{channels.length > 1 ? these : this} channel."
      end
    end
  end
end
