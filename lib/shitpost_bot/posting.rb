module ShitpostBot
  module Posting
    def self.get_reply(text, channel)
      if channel.torch_checkpoint?
        text = Processing.strip_missing_characters(text, channel.valid_characters)
        response = TorchRnn.sample(checkpoint: "data/checkpoints/#{channel.checkpoint}/#{channel.checkpoint}.t7",
                                 start_text: text,
                                 temperature: channel.temperature,
                                 gpu: CONFIG.gpu,
                                 gpu_backend: CONFIG.gpu_backend)
      elsif channel.word_checkpoint?
        response = WordRnnTensorflow.sample(save_dir:"data/checkpoints/#{channel.checkpoint}/",
                                  n: 1000,
                                  prime: text)
      end
      puts "TEXT: #{text}"
      puts "RESP1: #{response}"
      response = response.partition(text)[2]
      response = response.partition(text)[2] if channel.word_checkpoint?
      puts "RESP2: #{response}"
      if response.include? '¥'
        response = response.partition('¥')[0]
      end
      puts "RESP3: #{response}"
      if response.include? '§'
        output = []
        until response.chomp.empty?
          response = response.partition('§')
          output << response[0] unless response[0].empty?
          response = response[2]
        end
      else
        output = [response]
      end
      output
    end
  end
end
