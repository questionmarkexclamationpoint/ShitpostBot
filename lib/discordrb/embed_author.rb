module Discordrb
  class EmbedAuthor
    def to_json(options={})
      {
        'icon_url' => @icon_url,
        'name' => name,
        'proxy_icon_url' => @proxy_icon_url,
        'url' => url
      }.to_json
    end
  end
end
