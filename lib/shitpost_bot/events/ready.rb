module ShitpostBot
  module Events
    module Ready
      extend Discordrb::EventContainer
      ready do
        puts 'wat'  
        STATS.active_channels = 0
        STATS.checkpoint_popularity = {}
        BOT.servers.each do |server| 
          server.text_channels.each do |channel|
            puts channel.name
            puts channel.active
            puts channel.checkpoint
            puts STATS.active_channels
            puts STATS.checkpoint_popularitys
            STATS.active_channels += 1 if channel.active
            STATS.checkpoint_popularity[channel.checkpoint] ||= 0
            STATS.checkpoint_popularity[channel.checkpoint] += 1
          end
        end
        nil
      end
    end
  end
end
