module IcalParser
  class DurationParser
    SECONDS_PER_WEEK = 604800
    SECONDS_PER_DAY = 86400
    SECONDS_PER_HOUR = 3600
    SECONDS_PER_MINUTE = 60

    def self.parse(string)
      weeks = /(\d+)W/.match(string) {|m| m[1].to_i } || 0
      days = /(\d+)D/.match(string) {|m| m[1].to_i } || 0
      hours = /(\d+)H/.match(string) {|m| m[1].to_i } || 0
      minutes = /(\d+)M/.match(string) {|m| m[1].to_i } || 0
      seconds = /(\d+)S/.match(string) {|m| m[1].to_i } || 0

      (weeks * SECONDS_PER_WEEK) + (days * SECONDS_PER_DAY) + (hours * SECONDS_PER_HOUR) + (minutes * SECONDS_PER_MINUTE) + seconds
    end
  end
end
