module Discordrb
  class Server
    attr_reader :config, :lock

    old_initialize = instance_method(:initialize)
    define_method(:initialize) do |data, bot, exists = true|
      old_initialize.bind(self).call(data, bot, exists)
      @config = ShitpostBot::ServerConfig.load_config(@id)
      @lock = Monitor.new
      create_methods
      self
    end

    def get_or_create_mapping(str)
      char = nil
      @lock.synchronize do
        char = self.next_character
        self.next_character = ShitpostBot::CharacterMapping.next_char(char)
        self.special_strings[str] = char
        self.mapped_characters += char unless self.special_characters.has_key?(char)
        self.special_characters[char] = str
      end
      char
    end

    private

    def create_methods
      @config.keys.each do |key|
        self.class.send(:define_method, key) do
          @config[key]
        end
        self.class.send(:define_method, "#{key}=") do |value|
          @config[key] = value
        end
      end
    end
  end
end