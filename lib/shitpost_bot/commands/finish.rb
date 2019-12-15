module ShitpostBot
  module Commands
    module Finish
      extend Discordrb::Commands::CommandContainer
      command([:finish, :f],
              description: 'Finishes the thought started in the given text.',
              usage: "#{BOT.prefix}(finish|f) <text>",
              min_args: 1
              ) do |event|
        typer = Thread.new do
          loop do
            event.channel.start_typing
            sleep(5)
          end
        end
        start_text = event.message.content.partition(' ')[2]
        text = "#{CharacterMapping::MESSAGE_SEPARATOR}#{Constants::USER_SEPARATOR}#{start_text}"
        output = Posting.get_reply(text, event.channel)
        output[0] = start_text + output[0].to_s
        typer.kill
        output.each do |o|
          event << o unless o.empty?
        end
        nil
      end
    end
  end
end
