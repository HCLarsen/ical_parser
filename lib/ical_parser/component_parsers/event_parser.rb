module IcalParser
  module EventParser
    include Parser

    PROPERTIES = {
      "SUMMARY" => {"parser" => TextParser, "once_only" => true, "optional" => true},
      "DESCRIPTION" => {"parser" => TextParser, "once_only" => true, "optional" => true},
      "LOCATION" => {"parser" => TextParser, "once_only" => true, "optional" => true},
      "UID" => {"parser" => TextParser, "once_only" => true, "optional" => false},
      "DTSTAMP" => {"parser" => DateTimeParser, "once_only" => true, "optional" => false},
      "DTSTART" => {"parser" => DateTimeParser, "once_only" => true, "optional" => false},
      "ORGANIZER" => {"parser" => CalAddressParser, "once_only" => true, "optional" => true},
      "ATTENDEE" => {"parser" => CalAddressParser, "once_only" => false, "optional" => true}
    }

    private

    def find_property(eventc, prop_name)
      prop_name.upcase!
      property = PROPERTIES[prop_name]
      regex = /#{prop_name}(?<params>;.+?)?:(?<value>.+?)\R/
      matches = eventc.scan(regex).map {|match| {"params" => match[0], "value" => match[1].strip} }
      if matches.count == 1
        property["parser"].parse(matches.first["value"])
      elsif matches.size > 1 && property["once_only"] == false
        matches.map do |match|
          property["parser"].parse(match["value"])
        end
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
