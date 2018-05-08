module IcalParser
  module EventParser
    PROPERTIES = {
      "SUMMARY" => {"parser" => TextParser, "once_only" => true, "optional" => true},
      "DESCRIPTION" => {"parser" => TextParser, "once_only" => true, "optional" => true},
      "LOCATION" => {"parser" => TextParser, "once_only" => true, "optional" => true},
      "UID" => {"parser" => TextParser, "once_only" => true, "optional" => false},
      "DTSTAMP" => {"parser" => DateTimeParser, "once_only" => true, "optional" => false},
      "DTSTART" => {"parser" => DateTimeParser, "once_only" => true, "optional" => false}
    }

    def self.find_property(eventc, prop_name)
      prop_name.upcase!
      property = PROPERTIES[prop_name]
      regex = /#{prop_name}:(.*?)\R(?=\w)/m

      matches = eventc.scan(regex)
      if matches.count == 1
        property["parser"].parse(matches.first.first.strip)
      elsif matches.size > 1
        raise "Invalid Event: #{prop_name} MUST NOT occur more than once"
      elsif !property["optional"]
        raise "Invalid Event: #{prop_name} is REQUIRED"
      else
        nil
      end
    end
  end
end
