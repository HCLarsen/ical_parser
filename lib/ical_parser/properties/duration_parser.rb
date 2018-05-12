module IcalParser
  module DurationParser
    SECONDS_PER_WEEK = 604800
    SECONDS_PER_DAY = 86400
    SECONDS_PER_HOUR = 3600
    SECONDS_PER_MINUTE = 60

    def self.parse(string)
      if /^(?<polarity>[+-])?P((?<days>\d+)D)?(T((?<hours>\d+)H)?((?<minutes>\d+)M)?((?<seconds>\d+)S)?)?$/ =~ string
        duration = (days.to_i * SECONDS_PER_DAY) + (hours.to_i * SECONDS_PER_HOUR) + (minutes.to_i * SECONDS_PER_MINUTE) + seconds.to_i

        polarity == "-" ? duration * -1 : duration
      elsif /^(?<polarity>[+-])?P(?<weeks>\d+)W$/ =~ string
        duration = weeks.to_i * SECONDS_PER_WEEK
        polarity == "-" ? duration * -1 : duration
      else
        raise "Invalid Duration format"
      end
    end
  end
end
