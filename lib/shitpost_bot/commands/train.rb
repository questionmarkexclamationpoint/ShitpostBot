module ShitpostBot
  module Commands
    module Train
      extend Discordrb::Commands::CommandContainer
      command(:train, 
              description: '',
              usage: "#{BOT.prefix}train <size (32-256)> <layers (1-3)> <dropout (0.0-0.9)> <epochs (1-500)> <name>",
              required_permissions: [:manage_server],
              arg_types: [Integer, Integer, Float, Integer]
              ) do |event, size, layers, dropout, epochs, name, *channels|
        #event.channel.send_message("This command is disabled for now. Please contact the bot's creator and have them train the bot for you. Sorry for the hassle!")
        #return # when this command can be used reasonably by an idiot it should be reinstated
        size ||= 128
        size = size.to_i.clamp(32, 256)
        layers ||= 2
        layers = layers.to_i.clamp(1, 3)
        dropout ||= 0.0
        dropout = dropout.to_f.clamp(0.0, 0.9)
        epochs ||= 50
        epochs = epochs.to_i.clamp(1, 500)
        name ||= event.channel.name
        event.channel.start_typing
        if File.exists?("#{Dir.pwd}/data/checkpoints/name")
          event << 'There is already a checkpoint with this name!'
          return
        end
        channels = Processing.process_channel_parameters(channels, event.channel)
        return if channels.empty?
        Processing.write_channels_to_file(channels, "#{Dir.pwd}/data/checkpoints/#{name}/#{name}.txt")
        Thread.new do
          TorchRnn.preprocess(input_txt: "#{Dir.pwd}/data/checkpoints/#{name}/#{name}.txt", 
                              output_h5: "#{Dir.pwd}/data/checkpoints/#{name}/#{name}_processed.h5",
                              output_json: "#{Dir.pwd}/data/checkpoints/#{name}/#{name}_processed.json",
                              quiet: true)
          a = TorchRnn.train(input_h5: "#{Dir.pwd}/data/checkpoints/#{name}/#{name}_processed.h5",
                         input_json: "#{Dir.pwd}/data/checkpoints/#{name}/#{name}_processed.json",
                         rnn_size: size,
                         num_layers: layers,
                         dropout: dropout,
                         max_epochs: epochs,
                         print_every: 1,
                         checkpoint_every: 0,
                         checkpoint_name: "#{Dir.pwd}/data/checkpoints/#{name}/#{name}",
                         gpu: CONFIG.gpu,
                         gpu_backend: CONFIG.gpu_backend)
          event.channel.start_typing
          files = Dir.entries("#{Dir.pwd}/data/checkpoints/#{name}/")
          r = Regexp.new(name + '_\d*\.(json|t7)')
          files.select! do |file|
            file =~ r
          end
          files.each do |file|
            type = file.rpartition('.')[2]
            File.rename("#{Dir.pwd}/data/checkpoints/#{name}/#{file}", "#{Dir.pwd}/data/checkpoints/#{name}/#{name}.#{type}")
          end
          event << 'Done training!'
        end
        event << 'I\'ve begun training! I\'ll message you when I\'m done.'
      end
    end
  end
end
