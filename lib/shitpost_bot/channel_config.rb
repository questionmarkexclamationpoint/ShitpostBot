module ShitpostBot
  module ChannelConfig
    extend StoreData

    @default_settings = load_file("#{Dir.pwd}/data/default_settings.yml")
    @channels = load_file("#{Dir.pwd}/data/channel_config.yml")

    def self.load_config(id)
      return @channels[id] if @channels.key?(id)

      conf = {}
      @channels[id] = conf
      @default_settings[:off].each do |key, value|
        conf[key] = value
      end
      LOGGER.info "created a new config entry for channel #{id}"

      @channels[id]
    end

    def self.save
      LOGGER.debug 'Saving channel config'
      save_to_file("#{Dir.pwd}/data/channel_config.yml", @channels) unless @channels.empty?
    end
    
    def self.default_settings
      @default_settings
    end
  end
end
