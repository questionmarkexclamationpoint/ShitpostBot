module ShitpostBot
  module Commands
    module Scrape
      extend Discordrb::Commands::CommandContainer
      command(:scrape,
              help_available: false) do |event|
        BOT.servers.each do |server, verbose|
          verbose = (verbose == 'true' || verbose.to_i == 1) ? true : false
          server.channels.each do |channel|
            begin
              log = channel.full_history(event.channel)
              last_message = messages.first
              conversationalized_log = []
              multi_post = last_message.content.empty? ? [] : [last_message.content]
              messages.each do |message|
                next if message.content.empty?
                if last_message.author == message.author
                  multi_post << message.content
                else
                  conversationalized_log << multi_post unless multi_post.empty?
                  multi_post = [message.content]
                end
                last_message = message
              end
              File.open("#{Dir.pwd}/data/text/#{channel.id}_conversation.yml", 'w') do |f|
                f << YAML.dump(JSON.parse(JSON.dump(conversationalized_log)))
              end
              if verbose
                File.open("#{Dir.pwd}/data/text/#{channel.id}.json", 'w') do |f|
                  f << JSON.dump(log)
                end
              end
            rescue Discordrb::Errors::NoPermission
              event << "No permission on #{server.name}::#{channel.name}, skipping"
            rescue => e
              event << "Encountered exception on #{server.name}::#{channel.name}, skipping"
              event << "Exception was: #{e}"
            end
            event << 'Done scraping!'
          end
        end
      end
    end
  end
end
