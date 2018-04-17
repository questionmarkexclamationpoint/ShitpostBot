module ShitpostBot
  module Events
    Dir["#{File.dirname(__FILE__)}/events/*.rb"].each { |file| require file }

    @events = [
      Heartbeat,
      Mention,
      Message,
      Ready
    ]

    def self.include!
      @events.each do |event|
        ShitpostBot::BOT.include!(event)
      end
    end
  end
end
