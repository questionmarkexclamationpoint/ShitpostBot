module Discordrb
  class Channel
    attr_reader :config
    
    old_initialize = instance_method(:initialize)
    define_method(:initialize) do |data, bot, exists = true|
      old_initialize.bind(self).call(data, bot, exists)
      if text?
        @config = ShitpostBot::ChannelConfig.load_config(@id)
        create_methods
      end
    end
    
    def write_to_file(filename)
      history = all_history
      #outputing straight to the file, rather than processing the string and then outputing.
      #this is because appending to the file is *much* faster than appending to a string for very long strings.
      open(filename, 'w') do |file|
        last_message = history.first
      #np = message.channel.symbols[:new_post]
      #nu = message.channel.symbols[:new_user]
        history.each do |message|
          content = Processing.format_message(message)
          unless content.empty?
            #file << np
            #file << nu unless last_message.user == message.user
            file << '§'
            file << '¥' unless last_message.user == message.user
            file << content
            last_message = message
          end
        end
      end
    end
    
    def recent_history(amount = 10)
      if amount > 100
        h = history(100)
        amount -= 100
      else
        h = history(amount)
        amount = 0
      end
      result = h
      while h.length > 0 && amount > 0
        a = (amount > 100 ? 100 : amount)
        amount -= a
        h = history(a, result.last.id)
        result += h
      end
      result.reverse
    end
    
    def all_history
      h = history(100)
      result = []
      while h.length > 0
        result += h
        h = history(100, result.last.id)
      end
      result.reverse
    end
    
    def update_config(attributes = {})
      @config.merge!(attributes) if attributes.is_a?(Hash)
    end
    
    def valid_characters
      @valid_characters = ((checkpoint == @last_checkpoint) ? @valid_characters : JSON.parse(File.read("data/checkpoints/#{checkpoint}/#{checkpoint}_processed.json"), )['token_to_idx'].keys)
      @last_valid_checkpoint = checkpoint
      @valid_characters
    end
    
    def word_checkpoint?
      files = Dir["data/checkpoints/#{checkpoint}/*"]
      files.include? "data/checkpoints/#{checkpoint}/input.txt"
    end
    
    def torch_checkpoint?
      files = Dir["data/checkpoints/#{checkpoint}/*"]
      files.include? "data/checkpoints/#{checkpoint}/#{checkpoint}.t7"
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
