module ShitpostBot
  module Processing
    def self.strip_missing_characters(text, present)
      result = text
      text.each_char do |char|
        unless present.include?(char)
          result.delete!(char)
        end
      end
      result
    end

    def self.write_channels_to_file(channels, filename)
      history = []
      channels.each do |channel|
        history += channel.full_history
      end
      #outputing straight to the file, rather than processing the string and then outputing.
      #this is because appending to the file is *much* faster than appending to a string for very long strings.
      File.open(filename, 'w') do |file|
        last_message = history.first
      #np = message.channel.symbols[:new_post]
      #nu = message.channel.symbols[:new_user]
        history.each do |message|
          content = format_message(message)
          unless content.empty?
            #file << np
            #file << nu unless last_message.user == message.user
            file << CharacterMapping::MESSAGE_SEPARATOR
            file << CharacterMapping::USER_SEPARATOR unless last_message.user == message.user
            file << content
            last_message = message
          end
        end
        file << CharacterMapping::MESSAGE_SEPARATOR + CharacterMapping::USER_SEPARATOR
      end
    end

    def self.full_write_channels_to_file(channels, filename)
      history = []
      channels.each do |channel|
        history += channel.full_history
      end
      File.open(filename, 'w') do |file|
        f << JSON.dump(history)
      end
    end

    def self.process_channel_parameters(channels, home_channel)
      return [home_channel] if channels.empty?
      channels.length.times do |i|
        channels[i] = ShitpostBot::BOT.channel(channels[i][2..-2].to_i, event.server)
        if channels[i].nil?
          BOT.send_message(home_channel, 'You\'ve given a non-existant channel.')
          return []
        elsif channels[i].voice?
          BOT.send_message(home_channel, 'This command only works with text channels.')
          return []
        end
      end
      channels
    end

    def self.format_message(message, is_response = false)
      return '' if (message.from_bot? && !is_response) ||
                   message.content[0] == ShitpostBot::BOT.prefix ||
                   message.content =~ /\bhttp(s?):\/\/[^ ]+\b/ ||
                   message.content == ''
      text = message.content
      ShitpostBot::CONFIG.ignored_patterns.each do |pattern|
        text.gsub!(Regexp.new(pattern + ' '), '')
        text.gsub!(Regexp.new(' ' + pattern), '')
        text.gsub!(Regexp.new(pattern), '')
      end
      text.chomp
    end

    def self.format_messages(messages, is_response = false)
      text = ''
      last_message = messages.first
      #np = message.channel.symbols[:new_post]
      #nu = message.channel.symbols[:new_user]
      messages.each do |message|
          content = format_message(message, is_response)
          unless content.empty?
            #text += np
            #text += nu unless last_message.user == message.user
            text += CharacterMapping::MESSAGE_SEPARATOR
            text += CharacterMapping::USER_SEPARATOR unless last_message.user == message.user
            text += content
            last_message = message
          end
      end
      text += CharacterMapping::MESSAGE_SEPARATOR + CharacterMapping::USER_SEPARATOR
      text
    end
  end
end
