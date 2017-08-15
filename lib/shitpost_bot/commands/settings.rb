module ShitpostBot
  module Commands
    module Settings
      extend Discordrb::Commands::CommandContainer
      command(:settings, 
              description: '',
              usage: "#{BOT.prefix}settings",
              help_available: true
              ) do |event, *channels|
        event.channel.start_typing
        channels = Processing.process_channel_parameters(channels, event.channel)
        return if channels.empty?
        channels.sort_by!{|channel| channel.name}
        text = ''
        channels.each do |channel|
          text += channel.name + "\n"
          channel.config.each do |key, value|
            text += "   #{key}: #{value}\n"
          end
          text += "\n"
        end
        event.channel.send_message(text)
      end
    end
  end
end
