module IcalParser
  module EventParser
    def self.find_text_property(eventc, prop_name)
      regex = /#{prop_name.upcase}:(.*?)\R(?=\w)/m

      matches = eventc.scan(regex)
      if matches.count == 1
        TextParser.unescape(matches.first.first.strip)
      elsif matches.size > 1
        raise "Invalid Event: #{propName} MUST NOT occur more than once"
      elsif !optional
        raise "Invalid Event: #{propName} is REQUIRED"
      else
        nil
      end
    end
  end
end
