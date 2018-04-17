module ShitpostBot
  module Commands
    module Readall
      extend Discordrb::Commands::CommandContainer
      command(:readall, 
              description: 'Downloads the server\'s chat logs, parses them to a format I understand, then saves them.',
              usage: "#{BOT.prefix}readall",
              help_available: true,
              max_args: 0
              ) do |event|
        event.channel.start_typing
        if event.user.id == ShitpostBot::Config.owner_id
          channels = event.server.text_channels
          Processing.write_channels_to_file(channels, "#{Dir.pwd}/data/text/#{event.channel.name}.txt")
          event.channel.send_message('Done reading!')
        else
          event.channel.send_message('Sorry, this command is only available to the owner of the bot.')
        end
      end
    end
  end
end
