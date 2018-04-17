module ShitpostBot
  module Commands
    module Finish
      extend Discordrb::Commands::CommandContainer
      command([:finish, :f],
              description: 'Finishes the thought started in the given text.',
              usage: "#{BOT.prefix}finish text",
              min_args: 1
              ) do |event|
        event.channel.start_typing
        start_text = event.message.content.partition(' ')[2]
        text = '§ ¥ ' + start_text
        output = Posting.get_reply(text, event.channel)
        output[0] = start_text + output[0].to_s
        output.each do |o|
          event << o
        end
        nil
      end
    end
  end
end
