module Util
  def self.syscall(*cmd)
    begin
      stdout, stderr, status = Open3.capture3(*cmd)
      stdout.slice!(0..-(1 + $/.size)) # strip trailing eol
    rescue => e
      LOGGER.error(e)
    end
  end
end
