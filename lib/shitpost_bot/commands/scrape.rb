module ShitpostBot
  module Commands
    module Scrape
      extend Discordrb::Commands::CommandContainer
      command(:scrape,
              help_available: false) do |event|
        event.channel.start_typing
        unless event.author.id == CONFIG.owner_id
          event << 'Only the owner of the bot can use this command.'
          return
        end
        event << 'Scraping all channels. This may take some time.'
        BOT.servers.values.each do |server|
          server.text_channels.each do |channel|
            begin
              channel.history(1)
            rescue Discordrb::Errors::NoPermission
              event.channel.send_message("No permission on #{channel.full_name}, skipping.")
              next
            end
            LOGGER.info("Processing #{channel.full_name}...")
            dir = "#{Dir.pwd}/data/text/"
            json = "#{dir}/#{channel.id}.json"
            yaml = "#{dir}/#{channel.id}_conversation.yml"
            txt = "#{dir}/#{channel.id}_conversation.txt"
            [json, yaml, txt].each do |filename|
              File.rename(filename, filename + '.bak') if File.exist?(filename)
            end
            begin
              Processing.write_channels_to_file([channel], txt)
              Processing.json_write_channels_to_file([channel], json)
              Processing.yaml_write_channels_to_file([channel], yaml)
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
