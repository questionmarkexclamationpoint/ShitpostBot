module ShitpostBot
  module Posting
    def self.get_reply(text, channel)
      text = Processing.strip_missing_characters(text, channel.valid_characters)
      response = TorchRnn.sample(checkpoint: "#{Dir.pwd}/data/checkpoints/#{channel.checkpoint}/#{channel.checkpoint}.t7",
                               start_text: text,
                               temperature: channel.temperature,
                               gpu: CONFIG.gpu,
                               gpu_backend: CONFIG.gpu_backend) # TODO Add stop token when I fix that issue on my torch-rnn branch
      response = response.partition(text)[2]
      if response.include? CharacterMapping::USER_SEPARATOR # TODO remove this when the above is done
        response = response.partition(CharacterMapping::USER_SEPARATOR)[0]
      end
      LOGGER.info("Posting in #{channel.full_name}:\n" +
                  "  Input: #{text}\n" +
                  "  Output: #{response}\n")
      output = response.split(CharacterMapping::MESSAGE_SEPARATOR).reject(&:empty?)
      STATS.posts_made += output.size
      output
    end
  end
end
