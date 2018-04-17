module ShitpostBot
  module Commands
    module Temperature
      extend Discordrb::Commands::CommandContainer
      command([:temperature, :temp], 
              description: 'This command alters the temperature of the bot for the given channel(s). The temperature is the bot\'s creativity. A higher temperature yields wilder results, while a lower temperature yields much of the same. Usually 0.5 is good.',
              usage: "#{BOT.prefix}(temperature|temp) (0.1 - 1.0) [\#channel1 [\#channel2 [...]]]",
              arg_types: [Float],
              required_permissions: [:manage_server]
              ) do |event, temperature, *channels|
        event.channel.start_typing
        channels = Processing.process_channel_parameters(channels, event.channel)
        return if channels.empty?
        temperature = temperature.to_f.clamp(0.1, 1.0)
        channels.each do |channel|
          channel.temperature = temperature
        end
        event << "I am now #{temperature * 100}\% creative in #{channels.length > 1 ? 'this channel' : 'these channels'}!"
      end
    end
  end
end
