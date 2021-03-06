module ShitpostBot
  module ServerConfig
    extend StoreData

    @servers = load_file("#{Dir.pwd}/data/server_config.yml")

    def self.load_config(id)
      return @servers[id] if @servers.key?(id)

      conf = {}
      @servers[id] = conf
      conf[:special_characters] = {}
      conf[:special_strings] = {}
      conf[:mapped_characters] = ''
      conf[:next_character] = CharacterMapping.next_char
      LOGGER.info "created a new config entry for server #{id}"

      @servers[id]
    end

    def self.save
      LOGGER.debug 'Saving server config'
      save_to_file("#{Dir.pwd}/data/server_config.yml", @servers) unless @servers.empty?
    end
  end
end