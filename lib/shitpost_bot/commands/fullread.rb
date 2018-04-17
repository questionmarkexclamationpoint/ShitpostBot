module ShitpostBot
  module Commands
    module Fullread
      extend Discordrb::Commands::CommandContainer
      command([:fullread, :fr],
              description: 'Downloads the given channels\' chat logs *and all available metadata*, then saves them. If no channels are provided, the channel this command was issued in is used instead.',
              usage: "#{ShitpostBot::BOT.prefix}read [\#channel1 [\#channel2 [...]]]]",
              help_available: true) do |event, *channels|
        event.channel.start_typing
        channels = Processing.process_channel_parameters(channels, event.channel)
        return if channels.empty?
        if event.user.id == CONFIG.owner_id
          Processing.full_write_channels_to_file(channels, "#{Dir.pwd}/data/text/#{event.channel.name}.json")
          event << 'Done reading!'
        else
          event << 'Sorry, this command is only available to the owner of the bot.'
        end
      end
    end
  end
end
