module Discordrb
  class Reaction
    def to_json(options={})
      {
        'count' => count,
        'id' => id,
        'me' => me,
        'name' => name
      }.to_json
    end
  end
end
