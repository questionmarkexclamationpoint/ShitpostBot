module ShitpostBot
  module Events
    module Ready
      extend Discordrb::EventContainer
      ready do
        STATS.active_channels = 0
        STATS.checkpoint_popularity = {}
        BOT.servers.each do |id, server| 
          server.text_channels.each do |channel|
            STATS.active_channels += 1 if channel.active
            STATS.checkpoint_popularity[channel.checkpoint] ||= 0
            STATS.checkpoint_popularity[channel.checkpoint] += 1
          end
        end
      end
    end
  end
end
