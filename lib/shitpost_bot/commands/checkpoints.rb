module ShitpostBot
  module Commands
    module Checkpoints
      extend Discordrb::Commands::CommandContainer
      command([:checkpoints, :c], 
              description: 'Displays all checkpoints whose names contain the given term. If none is provided, displays all checkpoints.',
              usage: "#{BOT.prefix}[checkpoints|c] [term]",
              max_args: 1
              ) do |event, term|
        term ||= ''
        event.channel.start_typing
        entries = Dir.entries('data/checkpoints')
        entries -= ['.', '..']
        entries.select! do |entry|
          entry[-3..-1] == '.t7' && entry.include?(term)
        end
        entries.length.times do |i|
          entries[i] = entries[i].rpartition('.')[0]
        end
        event.channel.send_message("Available checkpoints#{term.empty? ?  '' : ' containing the given term'}: #{entries.join(', ')}")
      end
    end
  end
end
