module IcalParser
  module DateOrDateTimeParser
    DATE_REGEX = /VALUE=DATE:\d{8}/
    DATE_TIME_REGEX = /\d{8}T\d{6}/

    def self.parse(string)
      if DATE_TIME_REGEX.match(string)
        DateTimeParser.parse(string)
      elsif DATE_REGEX.match(string)
        DateParser.parse(string)
      end
    end
  end
end
