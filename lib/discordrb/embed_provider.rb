module Discordrb
  class EmbedProvider
    def to_json(options = {})
      {
        'name' => name,
        'url' => url
      }.to_json
    end
  end
end
