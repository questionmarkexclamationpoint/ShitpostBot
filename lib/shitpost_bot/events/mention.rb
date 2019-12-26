module ShitpostBot
  module Events
    module Mention
      extend Discordrb::EventContainer
      mention do |event|
        STATS.mentions += 1
        if event.channel.mention && event.content[0] != BOT.prefix
          event.channel.start_typing
          messages = event.channel.history(10, event.message.id).reverse
          content = event.content
          content = content[BOT.profile.mention.length..-1].lstrip if content.start_with?(BOT.profile.mention)
          messages << content unless content.empty?
          start_text = Processing.format_messages(messages.each, with_bot: true).to_a.join
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
