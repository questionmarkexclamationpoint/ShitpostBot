module ShitpostBot
  module Events
    module Heartbeat
      extend Discordrb::EventContainer
      heartbeat do |event|
        BOT.servers.each do |id, server|
          server.text_channels.each do |channel|
            if rand < channel.think
              channel.start_typing
              post = Posting.get_reply("#{Constants::MESSAGE_SEPARATOR}#{Constants::USER_SEPARATOR}", channel)
              post.each do |p|
                channel.send_message(p) unless p.empty?
              end
              nil
            end
          end
        end
      end
    end
  end
end
