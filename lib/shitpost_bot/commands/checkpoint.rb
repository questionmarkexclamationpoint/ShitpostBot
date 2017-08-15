module ShitpostBot
  module Commands
    module Checkpoint
      extend Discordrb::Commands::CommandContainer
      command(:checkpoint, 
              description: 'Changes the checkpoint for this channel to a given checkpoint.',
              usage: "#{ShitpostBot::BOT.prefix}[checkpoint|c] name [\#channel1 [\#channel2 [...]]]",
              required_permissions: [:manage_server],
              min_args: 1
              ) do |event, checkpoint, *channels|
        event.channel.start_typing
        if channels.empty?
          channels = [event.channel]
        else
          channels.length.times do |i|
            channels[i] = ShitpostBot::BOT.channel(channels[i][2..-2].to_i, event.server)
            if channels[i].nil?
              event.channel.send_message('You\'ve given a non-existant channel.')
              return
            elsif channels[i].voice?
              event.channel.send_message('This command only works with text channels.')
              return
            end
          end
        end
        unless File.exists?("data/checkpoints/#{checkpoint}/")
          event.channel.send_message("The given checkpoint doesn\'t exist. Try the `#{ShitpostBot::BOT.prefix}checkpoints` command.")
          return
        end
        channels.each do |channel|
          channel.checkpoint = checkpoint
        end
        event.channel.send_message('Settings updated!')
      end
    end
  end
end
