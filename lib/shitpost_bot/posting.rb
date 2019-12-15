module ShitpostBot
  module Posting
    def self.get_reply(text, channel)
      if channel.torch_checkpoint?
        text = Processing.strip_missing_characters(text, channel.valid_characters)
        response = TorchRnn.sample(checkpoint: "#{Dir.pwd}/data/checkpoints/#{channel.checkpoint}/#{channel.checkpoint}.t7",
                                 start_text: text,
                                 temperature: channel.temperature,
                                 gpu: CONFIG.gpu,
                                 gpu_backend: CONFIG.gpu_backend)
      elsif channel.word_checkpoint?
        response = WordRnnTensorflow.sample(save_dir:"#{Dir.pwd}/data/checkpoints/#{channel.checkpoint}/",
                                  n: 1000,
                                  prime: text)
      end
      response = response.partition(text)[2]
      response = response.partition(text)[2] if channel.word_checkpoint?
      if response.include? CharacterMapping::USER_SEPARATOR
        response = response.partition(CharacterMapping::USER_SEPARATOR)[0]
      end
      LOGGER.info("Posting in #{channel.full_name}:\n" +
                  "  Input: #{text}\n" +
                  "  Output: #{response}\n")
      if response.include? CharacterMapping::MESSAGE_SEPARATOR
        output = []
        until response.chomp.empty?
          response = response.partition(CharacterMapping::MESSAGE_SEPARATOR)
          output << response[0] unless response[0].empty?
          response = response[2]
        end
      else
        output = [response]
      end
      STATS.posts_made += 1
      output
    end
  end
end
