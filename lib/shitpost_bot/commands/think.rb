module ShitpostBot
  module Commands
    module Think
      extend Discordrb::Commands::CommandContainer
      command([:think], 
              description: 'Enables original thoughts on the channel with a given frequency between 0.0 (I won\'t post any original thoughts) and 1.0 (I\'ll post original thoughts constantly). If no frequency is provided, the thought frequency is instead switched between 0.0 and 0.01.',
              usage: "#{BOT.prefix}think [0.0 - 1.0]",
              arg_types: [Float],
              required_permissions: [:manage_server]
              ) do |event, frequency, *channels|
        event.channel.start_typing
        channels = Processing.process_channel_parameters(channels, event.channel)
        return if channels.empty?
        channels.each do |channel|
          channel.think = frequency
        end
        event.channel.send_message('Settings updated!')    
      end
    end
  end
end
