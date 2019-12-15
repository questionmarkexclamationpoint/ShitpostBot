module ShitpostBot
  module Events
    module Mention
      extend Discordrb::EventContainer
      mention do |event|
        STATS.mentions += 1
        if event.channel.mention && event.content[0] != BOT.prefix
          typer = Thread.new do
            loop do
              event.channel.start_typing
              sleep(5)
            end
          end
          start_text = Processing.format_messages(event.channel.history, true)
          start_text = start_text[-500..-1] if start_text.length > 500
          reply = Posting.get_reply(start_text, event.channel)
          typer.kill
          reply.each do |r|
            event << r unless r.empty?
          end
          nil
        end
      end
    end
  end
end
