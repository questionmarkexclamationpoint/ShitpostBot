module Util
  def self.syscall(*cmd)
    begin
      stdout, stderr, status = Open3.capture3(*cmd)
      puts "ERROR: #{stderr}" unless stderr.chomp.empty?
      stdout.slice!(0..-(1 + $/.size)) # strip trailing eol
    rescue => e
      puts e
    end
  end
end
