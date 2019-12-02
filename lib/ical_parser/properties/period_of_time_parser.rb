module IcalParser
  class PeriodOfTimeParser
    include Singleton

    def self.parser
      self.instance
    end

    def parse(value)
      parts = value.split("/")
      if parts.count == 2
      else
        raise "Invalid Period of Time format"
      end
    end
  end
end
