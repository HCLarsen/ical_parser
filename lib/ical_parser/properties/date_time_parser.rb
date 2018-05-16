require 'tzinfo'
require 'time'

module IcalParser
  module DateTimeParser
    def self.parse(string)
      dTUTCRegex = /^\d{8}T\d{6}Z$/
      dTRegex = /^\d{8}T\d{6}(?!Z)$/
      dTTZRegex = /TZID=\w*\/\w*:\d{8}T\d{6}$/

      if dTUTCRegex.match(string)
        Time.parse(string)
      elsif dTRegex.match(string)
        Time.parse(string)
      elsif dTTZRegex.match(string)
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
