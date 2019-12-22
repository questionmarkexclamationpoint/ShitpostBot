module ShitpostBot
  module Events
    module Message
      extend Discordrb::EventContainer
      message do |event|
        unless event.content.empty? || event.content[0] == BOT.prefix || rand >= event.channel.reply.to_f || (event.channel.mention && event.message.bot_mention?)
          event.channel.start_typing
          start_text = Processing.format_messages(event.channel.history.each).to_a
          start_text = start_text[-500..-1] if start_text.length > 500
          reply = Posting.get_reply(start_text, event.channel)
          reply.each do |r|
            event << r unless r.empty?
          end
          nil
        end
      end
    end
  end
end
