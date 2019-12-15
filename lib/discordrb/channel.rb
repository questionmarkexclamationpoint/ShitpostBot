module Discordrb
  class Channel
    attr_reader :config
    alias :old_history :history
    remove_method :history
    
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
    
    def each_message(log = false)
      return enum_for(:each_message, log) unless block_given?
      queue = Queue.new
      consumer = Thread.new do
        while true do
          yield queue.pop
        end
      end
      producer = Thread.new do
        curr = history(1, nil, 0)
        if curr.empty?
          consumer.kill
          Thread.exit
        end
        curr = curr[0]
        queue << curr
        i = 1
        notify_amount = 100
        old_pow = notify_amount
        until (h = history(100, nil, curr.id).reverse).empty?
          h.each{ |message| queue << message }
          i += h.size
          if i >= notify_amount && log
            LOGGER.info("Found #{i} messages on #{full_name}...") if log
            old_pow *= 10 if notify_amount == old_pow * 10
            notify_amount += old_pow
          end
          curr = h.last
        end
        until queue.empty? do
          nil
        end
        consumer.kill
        LOGGER.info("Returned #{i} messages from #{full_name}.") if log
      end
      producer.join
      nil
    end
    
    
    def history(amount = 10, before_id = nil, after_id = nil, around_id = nil, log = false)
      around = before_id.nil? && after_id.nil? && !around_id.nil?
      result = []
      notify_amount = 100
      if around
        amount -= 1 if amount.odd?
        h = amount <= 0 ? [] : old_history(1, nil, nil, around_id)
        result = h
        i = h.length
        before_done = false
        after_done = false
        while before.length > 0 && after.length && h.length > 0
          
          LOGGER.info("Found #{result.length} messages on #{full_name}...") if (i - 1) % notify_amount == 0 && log
          notify_amount *= 10 if i >= notify_amount * 10
          a = (amount > 100 ? 100 : amount)

          before_amount = after_done ? a : a / 2
          before = old_history(before_amount, result.last.id)
          before_done = before.empty?

          after_amount = before_done ? a : a / 2
          after = old_history(after_amount, result.first.id)
          after_done = after.empty?

          amount -= before.length + after.length
          result = [before, result, after].flatten
        end
      else
        if amount > 100
          h = old_history(100, before_id, after_id)
          amount -= 100
        else
          h = old_history(amount, before_id, after_id)
          amount = 0
        end
        i = h.length
        result = h
        while h.length > 0 && amount > 0
          LOGGER.info("Found #{result.length} messages on #{full_name}...") if i % notify_amount == 0 && log
          a = (amount > 100 ? 100 : amount)
          amount -= a
          h = old_history(a, result.last.id)
          i += h.length
          notify_amount *= 10 if i >= notify_amount * 10
          result += h
        end
      end
      LOGGER.info("Returning #{result.length} messages from #{full_name}.") if log
      result
    end
    
    def full_history(log = false)
      return history(Float::INFINITY, nil, nil, nil, log).reverse
    end
    
    def update_config(attributes = {})
      @config.merge!(attributes) if attributes.is_a?(Hash)
    end
    
    def valid_characters
      @valid_characters = checkpoint == @last_checkpoint \
        ? @valid_characters \
        : JSON.parse(File.read("#{Dir.pwd}/data/checkpoints/#{checkpoint}/#{checkpoint}_processed.json"), )['token_to_idx'].keys
      @valid_characters = @valid_characters.to_set
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
