module Discordrb
  class EmbedFooter
    def to_json(options = {})
      {
        'icon_url' => @icon_url,
        'proxy_icon_url' => @proxy_icon_url,
        'text' => text
      }.to_json
    end
  end
end
