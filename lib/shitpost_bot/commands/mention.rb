module ShitpostBot
  module Commands
    module Mention
      extend Discordrb::Commands::CommandContainer
      command([:mention, :m], 
              description: 'Enables/disables responses in the channel when the bot is mentioned. If replies are also enabled, the bot will *not* double post.',
              usage: "#{BOT.prefix}[mention|m] [\#channel1 [\#channel2 [...]]]",
              required_permissions: [:manage_server]
              ) do |event, *channels|
        event.channel.start_typing
        channels = Processing.process_channel_parameters(channels, event.channel)
        return if channels.empty?
        off = true
        channels.each do |channel|
          if channel.mention
            off = false 
            break
          end
        end
        channels.each do |channel|
          channel.mention = off
        end
        event.channel.send_message('Settings updated!')
      end
    end
  end
end
