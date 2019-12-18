module ShitpostBot
  class Config
    include StoreData
    
    def initialize
      @file = "#{Dir.pwd}/data/config.yml"
      temp = load_file(@file)
      @config = temp if temp.is_a?(Hash) && !temp.empty?
      setup_config if @config.nil?
      create_methods
    end

    private

    def setup_config
      @config = {}

      puts 'There is no config file, running the setup'
      puts 'Enter your discord token'
      @config[:discord_token] = gets.chomp

      puts 'Enter your discord client/application ID'
      @config[:discord_client_id] = gets.chomp

      puts 'Enter your torch-rnn install location [~/torch-rnn]'
      @config[:torch_rnn_location] = File.expand_path(gets.chomp)
      @config[:torch_rnn_location] = File.expand_path('~/torch-rnn') if @config[:torch_rnn_location].empty?
      
      while @config[:gpu].nil? || @config[:gpu] < -1
        puts 'Enter your gpu (typically 0 [primary gpu] or -1 [cpu]) [0]'
        @config[:gpu] = gets.chomp
        @config[:gpu] = 0 if @config[:gpu].empty?
      end
      
      until @config[:gpu_backend] == 'cuda' || @config[:gpu_backend] == 'opencl'
        puts 'Enter your gpu backend (cuda/opencl) [cuda]'
        @config[:gpu_backend] = gets.chomp
        @config[:gpu_backend] = 'cuda' if @config[:gpu_backend].empty?
      end

      puts 'Enter owner id [178950134263054337]'
      @config[:owner_id] = gets.chomp
      @config[:owner_id] = 178950134263054337 if @config[:owner_id].empty?

      puts 'Enter your prefix [!]'
      @config[:prefix] = gets.chomp
      @config[:prefix] = '!' if @config[:prefix].empty?
      
      @config[:ignored_patterns] = ['\bhttp(s?):\/\/[^ ]+\b']
      
      save
    end

    def create_methods
      @config.keys.each do |key|
        self.class.send(:define_method, key) do
          @config[key]
        end
      end
    end

    def save
      save_to_file(@file, @config)
    end
  end
end
