module Discordrb
  class Message
    def bot_mention?
      mentions.each do |user|
        return true if user.current_bot?
      end
      false
    end
  end
end
