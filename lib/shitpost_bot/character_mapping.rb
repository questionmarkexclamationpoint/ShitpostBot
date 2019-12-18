module ShitpostBot
  module CharacterMapping
    MESSAGE_SEPARATOR = [0xE000].pack("U*").freeze
    USER_SEPARATOR = [0xE001].pack("U*").freeze
    ENCODING_CHARACTERS = [
      ([0xE002].pack("U*")..[0xF8FF].pack("U*")).freeze,
      ([0xF0000].pack("U*")..[0xFFFFD].pack("U*")).freeze,
      ([0x100000].pack("U*")..[0x10FFFD].pack("U*")).freeze
    ].freeze

    # See https://discordapp.com/developers/docs/reference
    USER = /<@(?:!)?(\d+)>/.freeze
    CHANNEL = /<#(\d+)>/.freeze
    ROLE = /<@&(\d+)>/.freeze
    EMOJI = /<:[A-Za-z0-9_]+:(\d+)>/.freeze
    ANIMATED_EMOJI = /<a:[A-Za-z0-9_]+:(\d+)>/.freeze
    ALL = /<(?:@(?:!|&)?|#|(?:(?:a)?:[A-Za-z0-9_]+:))(\d+)>/.freeze

    def self.each_regex
      return to_enum(:each_regex) unless block_given?
      [
        USER,
        CHANNEL,
        ROLE,
        EMOJI,
        ANIMATED_EMOJI
      ].each do |v|
        yield v
      end
    end

    def self.next_char(curr)
      ENCODING_CHARACTERS.each do |range|
        return range.min if curr < range.min
        return curr.succ if curr < range.max
      end
      nil
    end
  end
end
