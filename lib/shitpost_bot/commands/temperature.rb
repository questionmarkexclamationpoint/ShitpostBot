module ShitpostBot
  module Commands
    module Temperature
      extend Discordrb::Commands::CommandContainer
      command([:temperature], 
              description: '',
              usage: "#{BOT.prefix}[temperature|temp] [0.1 - 1.0]",
              arg_types: [Float],
              required_permissions: [:manage_server]
              ) do |event, temperature, *channels|
        event.channel.start_typing
        channels = Processing.process_channel_parameters(channels, event.channel)
        return if channels.empty?
        channels.each do |channel|
          channel.temperature = temperature
        end
        event.channel.send_message('Settings updated!')
      end
    end
  end
end
