module Util
  def self.syscall(*cmd)
    begin
      stdout, stderr, status = Open3.capture3(*cmd)
      stdout.slice!(0..-(1 + $/.size)) # strip trailing eol
    rescue => e
      puts e
    end
  end
  
  def time_in_words(time)
    days = (time / 86_400).to_i
    time -= days * 86_400
    hours = (time / 3_600).to_i
    time -= hours
    minutes = (time / 60).to_i
    string = "#{days} day#{'s' unless days == 1},"
    string << " #{hours} hour#{'s' unless hours == 1},"
    string << " #{minutes} minute#{'s' unless minutes == 1}"
  end
end
