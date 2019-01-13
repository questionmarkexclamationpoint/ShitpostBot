module Discordrb
  class Message
    def bot_mention?
      mentions.each do |user|
        return true if user.current_bot?
      end
      false
    end
    def to_json(options = {})
      r = []
      reactions.each do |name, reaction|
        r << reaction
      end
      
      {
        'author' => author.id,
        'channel' => channel.id,
        'content' => content,
        'channel_name' => channel.name,
        'server_name' => channel.server.name,
        'edited' => edited,
        'edited_timestamp' => edited_timestamp,
        'id' => id,
        'embeds' => embeds,
        'mention_everyone' => mention_everyone,
        'mentions' => mentions.map(&:id),
        'nonce' => nonce,
        'pinned' => pinned,
        'server' => channel.server.id,
        'timestamp' => timestamp,
        'tts' => tts,
        'webhook_id' => webhook_id
      }.to_json
    end
  end
end
