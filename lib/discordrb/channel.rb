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
      history = full_history
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
            file << Constants::MESSAGE_SEPARATOR
            file << Constants::USER_SEPARATOR unless last_message.user == message.user
            file << content
            last_message = message
          end
        end
      end
    end
    
    def write_json_to_file(filename)
      history = full_history
      File.open(filename, 'w') do |file|
        f << JSON.dump(history)
      end
    end
    
    def each_message(postback_channel = nil)
      return enum_for(:each_message, postback_channel) unless block_given?
      curr = history(1, nil, 0)
      return if curr.empty?
      curr = curr[0]
      yield curr
      i = 1
      notify_amount = 100
      old_pow = notify_amount
      until (h = history(100, nil, curr.id).reverse).empty?
        h.each{ |message| yield message }
        i += h.size
        if i >= notify_amount && !postback_channel.nil?      
          postback_channel.send_message("Processed #{i} messages on #{full_name}...")
          old_pow *= 10 if notify_amount == old_pow * 10
          notify_amount += old_pow
        end
        curr = h.last
      end
      postback_channel.send_message("Done processing #{full_name}.") \
          unless postback_channel.nil?
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
    
    def full_history(postback_channel = nil)
      h = history(100)
      result = []
      i = h.length
      notify_amount = 100
      while h.length > 0
        postback_channel.send_message("Processed #{i} messages on #{full_name}...") if i % notify_amount == 0 && !postback_channel.nil?
        result += h
        h = history(100, result.last.id)
        i += h.length
        notify_amount *= 10 if i >= notify_amount * 10
      end
      postback_channel.send_message("Done processing. Processed #{i} messages on #{full_name} in total.") unless postback_channel.nil?
      result.reverse
    end
    
    def update_config(attributes = {})
      @config.merge!(attributes) if attributes.is_a?(Hash)
    end
    
    def valid_characters
      @valid_characters = ((checkpoint == @last_checkpoint) ? @valid_characters : JSON.parse(File.read("#{Dir.pwd}/data/checkpoints/#{checkpoint}/#{checkpoint}_processed.json"), )['token_to_idx'].keys)
      @last_valid_checkpoint = checkpoint
      @valid_characters
    end
    
    def word_checkpoint?
      files = Dir["#{Dir.pwd}/data/checkpoints/#{checkpoint}/*"]
      files.include? "#{Dir.pwd}/data/checkpoints/#{checkpoint}/input.txt"
    end
    
    def torch_checkpoint?
      files = Dir["#{Dir.pwd}/data/checkpoints/#{checkpoint}/*"]
      files.include? "#{Dir.pwd}/data/checkpoints/#{checkpoint}/#{checkpoint}.t7"
    end
    
    def active
      mention || reply > 0 || think > 0
    end
    
    def full_name
      "#{server.name}::#{name}"
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
