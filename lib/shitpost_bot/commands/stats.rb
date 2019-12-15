module ShitpostBot
  module Commands
    module Stats
      extend Discordrb::Commands::CommandContainer
      command(:stats,
              description: 'Displays some statistics about me.',
              usage: "#{BOT.prefix}stats",
              help_available: true
              ) do |event|
        ping = ((Time.now - event.timestamp) * 1000).to_i
        event << "\nServers: #{STATS.servers}"
        event << "Posts made: #{STATS.posts_made}"
        event << "Active channels: #{STATS.active_channels}"
        event << 'Checkpoint popularity:'
        STATS.checkpoint_popularity.each do |key, value|
          event << "  #{key}: #{value}"
        end
        event << "Times mentioned: #{STATS.mentions}"
        event << "Uptime: #{ChronicDuration.output(STATS.uptime)}"
        event << "Ping: #{ping}ms"
      end
    end
  end
end
