require 'tzinfo'
require 'time'

module IcalParser
  module DateTimeParser
    DT_UTC_REGEX      = /^\d{8}T\d{6}Z$/
    DT_FLOATING_REGEX = /^\d{8}T\d{6}$/
    DT_TIME_ZONE_REGEX = /TZID=\w*\/\w*:\d{8}T\d{6}$/

    def self.parse(string)

      if DT_UTC_REGEX.match(string)
        Time.parse(string)
      elsif DT_FLOATING_REGEX.match(string)
        Time.parse(string)
      elsif DT_TIME_ZONE_REGEX.match(string)
        self.parse_date_time_with_zone(string)
      else
        raise "Invalid Date-Time format"
      end
    end

    private

    def self.parse_date_time_with_zone(string)
      /TZID=(?<tzid>.*):(?<date_string>\d{8})T(?<time_string>\d{6})/ =~ string
      time = Time.parse(string)
      utc_time = (time + time.utc_offset).utc
      offset = self.offset(tzid, time.dst?)
      utc_time - offset
    end

    def self.offset(tzid, dst = false)
      tz = TZInfo::Timezone.get(tzid)
      if dst
        offset = tz.current_period.offset.utc_total_offset
      else
        offset = tz.current_period.offset.utc_offset
      end
    end
  end
end
