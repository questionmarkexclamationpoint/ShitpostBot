module Discordrb
  class EmbedThumbnail
    def to_json(options = {})
      {
        'height' => height,
        'proxy_url' => proxy_url,
        'url' => url,
        'width' => width
      }.to_json
    end
  end
end
