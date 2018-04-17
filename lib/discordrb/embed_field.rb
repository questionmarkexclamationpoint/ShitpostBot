module Discordrb
  class EmbedField
    def to_json(options = {})
      {
        'inline' => inline,
        'name' => name,
        'value' => value
      }.to_json
    end
  end
end
