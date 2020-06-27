module ShitpostBot
  module Processing
    def self.strip_missing_characters(text, present)
      result =text
      text.each_char do |char|
        unless present.include?(char)
          result.delete!(char)
        end
      end
      result
    end

    def self.write_channels_to_file(channels, filename)
      File.open(filename, 'w') do |file|
        channels[0..-2].each do |channel|
          format_messages(channel.each_message, with_tail: true) do |message|
            file << message
          end
        end
        format_messages(channels.last.each_message, with_tail: true) do |message|
          file << message
        end
      end
    end

    def self.json_write_channels_to_file(channels, filename)
      File.open(filename, 'w') do |file|
        file << "[\n"
        channels.each do |channel|
          channel.each_message do |message|
            file << JSON.dump(message) << ",\n"
          end
        end
        file << "]"
      end
    end

    def self.yaml_write_channels_to_file(channels, filename)
      File.open(filename, 'w') do |file|
        file << '---'
        last_poster = nil
        channels.each do |channel|
          channel.each_message do |message|
            next if message.content.empty?
            pre = message.user == last_poster ? '- ' : '  '
            pre += message.content.include?("\n") ? "- |-\n  " : '- '
            file << "\n" + pre + message.content.lines.map{|l| '    ' + l}.join
            last_poster = message.user
          end
        end
      end
    end

    def self.process_channel_parameters(channels, home_channel)
      return [home_channel] if channels.empty?
      channels.length.times do |i|
        channels[i] = ShitpostBot::BOT.channel(channels[i][2..-2].to_i, event.server)
        if channels[i].nil?
          BOT.send_message(home_channel, 'You\'ve given a nonexistent channel.')
          return []
        elsif channels[i].voice? || channels[i].category?
          BOT.send_message(home_channel, 'This command only works with text channels.')
          return []
        end
      end
      channels
    end

    def self.format_message(message, with_bot = false)
      text = message.content
      text = text[BOT.profile.mention.length..-1].lstrip if text.start_with?(BOT.profile.mention)
      return '' if (message.from_bot? && ! with_bot) ||
          text[0] == ShitpostBot::BOT.prefix ||
          text == ''
      ShitpostBot::CONFIG.ignored_patterns.each do |pattern|
        text.gsub!(Regexp.new(pattern + ' '), '')
        text.gsub!(Regexp.new(' ' + pattern), '')
        text.gsub!(Regexp.new(pattern), '')
      end
      text.gsub(CharacterMapping::ALL){|capture| message.channel.server.get_or_create_mapping(capture)}.strip
    end

    def self.map_special_characters(text, server)
      ret = nil
      server.lock.synchronize do
        ret = text
        ret.gsub!(Regexp.new('[' + server.mapped_characters + ']')){|v| server.special_characters[v]} \
            unless server.mapped_characters.nil? || server.mapped_characters.empty?
      end
      ret
    end

    def self.format_messages(enumerator, with_tail: true, with_bot: false)
      return to_enum(:format_messages, enumerator, with_tail: with_tail, with_bot: with_bot) unless block_given?
      last_poster = nil
      non_zero = false
      enumerator.each do |message|
        non_zero = true
        content = format_message(message, with_bot)
        unless content.empty?
          yield "#{CharacterMapping::MESSAGE_SEPARATOR}#{last_poster == message.user ? '' : CharacterMapping::USER_SEPARATOR}#{content}"
          last_poster = message.user
        end
      end
      yield (CharacterMapping::MESSAGE_SEPARATOR + CharacterMapping::USER_SEPARATOR) if with_tail && non_zero
    end
  end
end
