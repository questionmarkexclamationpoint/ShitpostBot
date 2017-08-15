module Util
  def self.syscall(*cmd)
    begin
      stdout, stderr, status = Open3.capture3(*cmd)
      stdout.slice!(0..-(1 + $/.size)) # strip trailing eol
    rescue => e
      puts e.message
    end
  end
end
