module ShitpostBot
  module Commands
    module Scrape
      extend Discordrb::Commands::CommandContainer
      command(:scrape,
              help_available: false) do |event|
        unless event.author.id == CONFIG.owner_id
          event.channel('Only the owner of the bot can use this command.')
          return
        end
        BOT.servers.sort_by(&:first).map(&:last).reverse.each do |server|
          server.text_channels.each do |channel|
            begin
              channel.history(1)
            rescue Discordrb::Errors::NoPermission
              event.channel.send_message("No permission on #{channel.full_name}, skipping.")
              next
            end
            event.channel.send_message("Processing #{channel.full_name}...")
            dir = "#{Dir.pwd}/data/text/"
            json = "#{dir}/#{channel.id}.json"
            yaml = "#{dir}/#{channel.id}_conversation.yml"
            txt = "#{dir}/#{channel.id}_conversation.txt"
            [json, yaml, txt].each do |filename|
              File.rename(filename, filename + '.bak') if File.exist?(filename)
            end
            begin
              last_message = nil
              json_file = File.open(json, 'w')
              yaml_file = File.open(yaml, 'w')
              txt_file = File.open(txt, 'w')
              json_file << '['
              yaml_file << '---'
              txt_file << Constants::MESSAGE_SEPARATOR
              i = 0
              channel.each_message(event.channel) do |message|
                i += 1
                puts i
                next if message.content.empty?
                is_new_user = last_message.nil? || last_message.user.id != message.user.id
                #json
                json_file << message.to_json + ','
                #yml -- manually formatting here
                pre = is_new_user ? '- ' : '  '
                pre += message.content.include?("\n") ? "- |-\n  " : '- '
                yaml_file << "\n" + pre + message.content.lines.map{ |l| '    ' + l }.join
                #txt
                proc = Processing.format_message(message)
                unless proc.empty?
                  txt_file << Constants::USER_SEPARATOR if is_new_user
                  txt_file << proc + Constants::MESSAGE_SEPARATOR
                end
                last_message = message
              end
              json_file.pos -= 1
              json_file << ']'
              yaml_file << '[]' if last_message.nil?
              yaml_file << "\n"
              txt_file << Constants::USER_SEPARATOR
              json_file.close
              yaml_file.close
              txt_file.close
            rescue Exception => e
              event.channel.send_message("Exception encountered on #{channel.full_name}, skipping.\n"\
                  + "Exception was:\n"\
                  + "```\n"\
                  + "#{e.full_message(highlight: false)}\n"\
                  + "```")
              [json, yaml, txt].each do |filename|
                File.delete(filename) if File.exist?(filename)
                File.rename(filename + '.bak', filename) if File.exist?(filename + '.bak')
              end
            else
              [json, yaml, txt].each do |filename|
                File.delete(filename + '.bak') if File.exist?(filename + '.bak')
              end
            end
          end
        end
        'Done scraping!'
      end
    end
  end
end
