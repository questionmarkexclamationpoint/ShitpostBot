module ShitpostBot
  module Posting
    def self.get_reply(text, channel)
      text = Processing.strip_missing_characters(text, channel.valid_characters)
      response = TorchRnn.sample(checkpoint: "#{Dir.pwd}/data/checkpoints/#{channel.checkpoint}/#{channel.checkpoint}.t7",
          start_text: text,
          temperature: channel.temperature,
          gpu: CONFIG.gpu,
          gpu_backend: CONFIG.gpu_backend,
          stop_token: CharacterMapping::USER_SEPARATOR)
      response = response.force_encoding('UTF-8').partition(text)[2].partition(CharacterMapping::USER_SEPARATOR)[0].rstrip
      LOGGER.info("Posting in #{channel.full_name}:\n" \
          + "  Input: #{text}\n" \
          + "  Output: #{response}\n")
      output = Processing.map_special_characters(response, channel.server)
          .split(CharacterMapping::MESSAGE_SEPARATOR)
          .reject(&:empty?)
      STATS.posts_made += output.size
      output
    end
  end
end
