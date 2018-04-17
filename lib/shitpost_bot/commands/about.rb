module ShitpostBot
  module Commands
    module About
      extend Discordrb::Commands::CommandContainer
      command([:about, :a],
              description: 'Shows some information about me.',
              usage: "#{BOT.prefix}about",
              max_args: 0,
              help_available: true
              ) do |event|
        event << 'Author: ?!#9874 (<@178950134263054337>)'
        event << "Owner: <@#{CONFIG.owner_id}>"
        event << 'Github: https://github.com/questionmarkexclamationpoint/ShitpostBot'
        event << "Version: #{VERSION}"
      end
    end
  end
end
