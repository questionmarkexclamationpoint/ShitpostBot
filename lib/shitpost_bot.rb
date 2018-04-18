require 'yaml'
require 'open3'
require 'json'

require 'discordrb'

module Kernel
  def run_supressed(&block)
    original_verbosity = $VERBOSE
    $VERBOSE = nil
    yield block
    $VERBOSE = original_verbosity
  end
end

module ShitpostBot
  run_supressed { Discordrb::LOG_TIMESTAMP_FORMAT = '%Y-%m-%d %H:%M:%S' }

  debug = ARGV.include?('-debug') ? :debug : false
  log_streams = [STDOUT]

  if debug
    timestamp = Time.now.strftime(Discordrb::LOG_TIMESTAMP_FORMAT).tr(':', '-')
    log_file = File.new("#{Dir.pwd}/logs/#{timestamp}.log", 'a+')
    log_streams.push(log_file)
  end

  run_supressed { LOGGER = Discordrb::LOGGER = Discordrb::Logger.new(nil, log_streams) }

  LOGGER.debug = true if debug
  require_relative 'shitpost_bot/store_data'
  require_relative 'shitpost_bot/config'

  Dir["#{File.dirname(__FILE__)}/discordrb/*.rb"].each do |file|
    require file
  end

  CONFIG = Config.new
  
  
  require_relative 'util'
  require_relative 'torch_rnn'
  require_relative 'word_rnn_tensorflow'

  BOT = Discordrb::Commands::CommandBot.new(token: CONFIG.discord_token,
                                            client_id: CONFIG.discord_client_id,
                                            prefix: CONFIG.prefix,
                                            advanced_functionality: false,
                                            fancy_log: true)

  Dir["#{File.dirname(__FILE__)}/shitpost_bot/*.rb"].each do |file|
    require file
  end
  
  STATS = Stats.new

  Commands.include!
  Events.include!
  
  TRAINING_LOCK = Mutex.new
  
  at_exit do
    LOGGER.info 'Saving files before exiting...'
    STATS.save
    ChannelConfig.save
    #ChannelSymbols.save
    exit!
  end
  
  LOGGER.info "Oauth url: #{BOT.invite_url}"
  LOGGER.info 'Use ctrl+c to safely stop the bot.'
  BOT.run(:async)

  loop do
    STATS.update
    ChannelConfig.save
    STATS.save
    sleep(10)
  end
end
