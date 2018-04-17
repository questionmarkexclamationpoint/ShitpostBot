module ShitpostBot
  module Commands
    module Checkpoints
      extend Discordrb::Commands::CommandContainer
      command([:checkpoints, :cs], 
              description: 'Displays all checkpoints whose names contain the given term. If none is provided, displays all checkpoints.',
              usage: "#{BOT.prefix}[checkpoints|cs] [term]",
              max_args: 1
              ) do |event, term|
        term ||= ''
        event.channel.start_typing
        entries = Dir.entries("#{Dir.pwd}/data/checkpoints")
        entries -= ['.', '..']
        entries.select!{|entry| File.directory?("#{Dir.pwd}/data/checkpoints/#{entry}") && entry.include?(term)}
        entries.reject!{|entry| Dir.entries("#{Dir.pwd}/data/checkpoints/#{entry}").any?{|f| f == 'config.pkl'}} # hiding word based checkpoints for now
        event.channel.send_message("Available checkpoints#{term.empty? ?  '' : ' containing the given term'}: #{entries.sort.join(', ')}")
      end
    end
  end
end
