module ShitpostBot
  module Events
    module Mention
      extend Discordrb::EventContainer
      mention do |event|
        if event.channel.mention && event.content[0] != BOT.prefix
          event.channel.start_typing
          start_text = Processing.format_messages(event.channel.recent_history, true)
          start_text = start_text[-100..-1] if start_text.length > 100
          reply = Posting.get_reply(start_text, event.channel)
          reply.each do |r|
            event.channel.send_message(r)
          end
          nil
        end
      end
    end
  end
end
