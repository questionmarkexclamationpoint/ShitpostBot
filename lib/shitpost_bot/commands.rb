module ShitpostBot
  module Commands
    Dir["#{File.dirname(__FILE__)}/commands/*.rb"].each { |file| require file }
    
    @commands = [
      About,
      Checkpoint,
      Checkpoints,
      Default,
      Disable,
      Finish,
      Fullread,
      Mention,
      Read,
      Readall,
      Reply,
      Scrape,
      Settings,
      Stats,
      Temperature,
      Think,
      Train
    ]
    
    def self.include!
      @commands.each do |command|
        ShitpostBot::BOT.include!(command)
      end
    end
  end
end
