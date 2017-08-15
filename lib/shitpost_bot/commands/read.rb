module ShitpostBot
  module Commands
    module Read
      extend Discordrb::Commands::CommandContainer
      command(:read, 
              description: 'Downloads the given channels\' chat logs, parses them to a format I understand, then saves them. If no channels are provided, the channel this command was issued in is used instead.',
              usage: "#{ShitpostBot::BOT.prefix}read [\#channel1 [\#channel2 [...]]]",
              help_available: true
              ) do |event, *channels|
        event.channel.start_typing
        channels = Processing.process_channel_parameters(channels, event.channel)
        return if channels.empty?
        if event.user.id == CONFIG.owner_id
          Processing.write_channels_to_file(channels, "data/text/#{event.channel.name}.txt")
          event.channel.send_message('Done reading!')
        else
          event.channel.send_message('Sorry, this command is only available to the owner of the bot.')
        end
      end
    end
  end
end