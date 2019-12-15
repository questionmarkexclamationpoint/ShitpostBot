module ShitpostBot
  module Events
    module Heartbeat
      extend Discordrb::EventContainer
      heartbeat do |event|
        BOT.servers.each do |id, server|
          server.text_channels.each do |channel|
            if rand < channel.think
              typer = Thread.new do
                loop do
                  channel.start_typing
                  sleep(5)
                end
              end
              post = Posting.get_reply(
                "#{CharacterMapping::MESSAGE_SEPARATOR}#{CharacterMapping::USER_SEPARATOR}", 
                channel
              )
              typer.kill
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
