require 'tzinfo'
require 'time'

module IcalParser
  module DateTimeParser
    def self.parse(string)
      dTUTCRegex = /^\d{8}T\d{6}Z/
      dTRegex = /^\d{8}T\d{6}(?!Z)/
      dTTZRegex = /\w:\d{8}T\d{6}/
      tzRegex = /TZID=(.*):/

      if dTUTCRegex.match(string)
        Time.parse(string)
      elsif dTRegex.match(string)
        Time.parse(string)
      elsif dTTZRegex.match(string)
        time = Time.parse(string)
        local_offset = time.utc_offset

        zone = tzRegex.match(string)[1]
        tz = TZInfo::Timezone.get(zone)

        if time.dst?
          offset = tz.current_period.offset.utc_total_offset
        else
          offset = tz.current_period.offset.utc_offset
        end

        time_zone_difference = local_offset - offset

        time + time_zone_difference
      end
    end
  end
end
