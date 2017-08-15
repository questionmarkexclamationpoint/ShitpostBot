module ShitpostBot
  module Commands
    module Stats
      extend Discordrb::Commands::CommandContainer
      command([:stats, :s],
              description: 'Displays some statistics about me.',
              usage: "#{BOT.prefix}train 0.01",
              help_available: true,
              max_args: 1
              ) do |event, frequency|
        
      end
    end
  end
end
