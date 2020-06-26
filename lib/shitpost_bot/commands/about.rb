module ShitpostBot
  module Commands
    module About
      extend Discordrb::Commands::CommandContainer
      command([:about, :a],
              description: 'Shows some information about me.',
              usage: "#{BOT.prefix}(about|a)",
              max_args: 0,
              help_available: true
              ) do |event|
        event << "Owner: <@#{CONFIG.owner_id}>"
        event << 'Github: https://github.com/questionmarkexclamationpoint/ShitpostBot'
        event << "Version: #{VERSION}"
      end
    end
  end
end
