module ShitpostBot
  module Commands
    module Checkpoint
      extend Discordrb::Commands::CommandContainer
      command([:checkpoint, :c],
              description: 'Changes the checkpoint for this channel to a given checkpoint.',
              usage: "#{ShitpostBot::BOT.prefix}[checkpoint|c] name [\#channel1 [\#channel2 [...]]]",
              required_permissions: [:manage_server],
              min_args: 1
              ) do |event, checkpoint, *channels|
        event.channel.start_typing
        channels = Processing.process_channel_parameters(channels, event.channel)
        return if channels.empty?
        path = "#{Dir.pwd}/data/checkpoints/#{checkpoint}/"
        unless File.exists?(path) && File.exists?(path + checkpoint + '.t7') && File.exists?(path + checkpoint + '_processed.json')
          event << "The given checkpoint doesn\'t exist. Try the `#{ShitpostBot::BOT.prefix}checkpoints` command."
          return
        end
        channels.each do |channel|
          STATS.checkpoint_popularity[channel.checkpoint] ||= 1
          STATS.checkpoint_popularity[checkpoint] ||= 0
          STATS.checkpoint_popularity[channel.checkpoint]
          STATS.checkpoint_popularity[checkpoint] += 1
          channel.checkpoint = checkpoint
        end
        event 'Settings updated!'
      end
    end
  end
end
