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
        size ||= 128
        layers ||= 2
        dropout ||= 0.0
        epochs ||= 50
        name ||= event.channel.name
        event.channel.start_typing
        channels = Processing.process_channel_parameters(channels, event.channel)
        return if channels.empty?
        ShitpostBot::Processing.write_channels_to_file(channels, "data/checkpoints/#{name}.txt")
        Thread.new do
          TorchRnn.preprocess(input_txt: "data/checkpoints/#{name}.txt", 
                              output_h5: "data/checkpoints/#{name}_processed.h5",
                              output_json: "data/checkpoints/#{name}_processed.json",
                              quiet: true)
          a = TorchRnn.train(input_h5: "data/checkpoints/#{name}_processed.h5",
                         input_json: "data/checkpoints/#{name}_processed.json",
                         rnn_size: size,
                         num_layers: layers,
                         dropout: dropout,
                         max_epochs: epochs,
                         print_every: 1,
                         checkpoint_every: 0,
                         checkpoint_name: "data/checkpoints/#{name}",
                         gpu: CONFIG.gpu,
                         gpu_backend: CONFIG.gpu_backend)
          event.channel.start_typing
          files = Dir.entries('data/checkpoints/')
          r = Regexp.new(name + '_\d*\.(json|t7)')
          files.select! do |file|
            file =~ r
          end
          files.each do |file|
            type = file.rpartition('.')[2]
            File.rename("data/checkpoints/#{file}", "data/checkpoints/#{name}.#{type}")
          end
          event.channel.send_message('Done training!')
        end
        event.channel.send_message('I\'ve begun training! I\'ll message you when I\'m done.')
      end
    end
  end
end
