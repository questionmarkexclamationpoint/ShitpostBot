module Discordrb
  class Embed
    def to_json(options = {})
      {
        'author' => author,
        'color' => @color,
        'description' => description,
        'fields' => @fields,
        'footer' => @footer,
        'image' => @image,
        'message' => message.id,
        'provider' => provider,
        'thumbnail' => thumbnail,
        'timestamp' => @timestamp,
        'title' => title,
        'type' => type,
        'url' => url,
        'video' => @video
      }.to_json
    end
  end
end
