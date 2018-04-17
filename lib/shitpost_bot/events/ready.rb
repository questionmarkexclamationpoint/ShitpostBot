module ShitpostBot
  module Events
    module Ready
      extend Discordrb::EventContainer
      ready do |event|
        @stats[:active_channels] = 0
        @stats[:checkpoint_popularity] = {}
        BOT.servers.each do |server| 
          server.text_channels.each do |channel|
            @stats[:active_channels] += 1 if channel.active
            @stats[:checkpoint_popularity][channel.checkpoint] ||= 0
            @stats[:checkpoint_popularity][channel.checkpoint] += 1
          end
        end
      end
    end
  end
end
