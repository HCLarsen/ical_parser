require 'tzinfo'

module IcalParser
  module TimeParser
    def self.parse(string, date = Time.now)
      dUTCRegex = /^\d{6}Z$/
      dRegex = /^\d{6}(?!Z)$/
      dTZRegex = /TZID=\w*\/\w*:\d{6}$/
      tzRegex = /TZID=(.*):/

      if dUTCRegex.match(string)
        time = Time.strptime(string, "%H%M%SZ")
        (time + time.utc_offset).utc
      elsif dRegex.match(string)
        Time.strptime(string, "%H%M%S")
      elsif dTZRegex.match(string)
        /TZID=(?<tzid>.*):(?<time_string>\d{6})/ =~ string
        time = Time.strptime(time_string, "%H%M%S", date)
        utc_time = (time + time.utc_offset).utc # Transform parsed time to UTC time.
        offset = self.offset(tzid, date.dst?) # Calculate offset
        utc_time - offset # Apply offset from timezone to time
      else
        raise "Invalid Time format"
      end
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
