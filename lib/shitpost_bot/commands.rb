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
      Mention,
      Read,
      Readall,
      Reply,
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
