module ShitpostBot
  module Commands
    module Train
      extend Discordrb::Commands::CommandContainer
      command(:train, 
              description: "Trains me using the conversation from this channel, and creates a new checkpoint with the specified name. There are a few things to take into consideration when training a bot. \n\nThe first is the size. The larger the neural network, the more brain capacity the checkpoint will have. However, if you use a large size on a small amount of text, it will tend to 'overfit' and produce results that are too rigid and uninteresting. The size of the neural network should depend on the amount of conversation you have in this channel. \n\nThe second thing to consider is the number of layers to use. More layers means more ability to abstract concepts. Usually 2 is ok. \n\nAdditionally, the dropout is important to consider. Dropout is the percentage of the neural network that the brain should randomly choose to not use during each iteration of training. It reselects this portion every iteration. This means that it trains different parts of its brain at each iteration, which leads to a better overall result once the dropout is turned off. Dropout is disabled when the bot actually goes to post. Keep in mind that a very high dropout will cause the bot to essentially not learn at all. \n\nFinally, the number of epochs should be considered. Typically, the longer you let your training run, the better it is. However, a large number of epochs on a server with a lot of conversation could potentially take a very long time to run. Usually 100 is ok.",
              usage: "#{BOT.prefix}train <size=128 [32-256]> <layers=2 [1-3]> <dropout=0.0 [0.0-0.9]> <epochs=50 [1-500]> <name=channelname>",
              required_permissions: [:manage_server],
              arg_types: [Integer, Integer, Float, Integer]
              ) do |event, size, layers, dropout, epochs, name, *channels|
        #event.channel.send_message("This command is disabled for now. Please contact the bot's creator and have them train the bot for you. Sorry for the hassle!")
        #return # when this command can be used reasonably by an idiot it should be reinstated
        size ||= 128
        size = size.to_i
        size = size.clamp(32, 256) unless event.user.id == CONFIG.owner_id
        layers ||= 2
        layers = layers.to_i
        layers = layers.clamp(1, 3) unless event.user.id == CONFIG.owner_id
        dropout ||= 0.0
        dropout = dropout.to_f.clamp(0.0, 0.9)
        epochs ||= 50
        epochs = epochs.to_i
        epochs = epochs.clamp(1, 500) unless event.user.id == CONFIG.owner_id
        name ||= event.channel.name
        name.gsub!(/[^0-9A-Za-z.\-_]/, '')
        event.channel.start_typing
        if File.exists?("#{Dir.pwd}/data/checkpoints/#{name}")
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
