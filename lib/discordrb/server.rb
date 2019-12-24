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
        char = next_char
        next_char = ShitpostBot::CharacterMapping.next_char(char)
        special_strings[str] = char
        mapped_chars += char unless special_characters.has_key?(char)
        special_characters[char] = str
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