module IcalParser
  module TextParser
    def self.unescape(string)
      string.gsub(/(\\(?!\\))/){ |match| "" }
    end

    def self.escape(string)
      string.gsub(/(\,|\;|\\[^n])/){ |match| "\\" + match }
    end

    def self.parse(propName, eventc, optional = true)
      regex = /#{propName.upcase}:(.*?)\R(?=\w)/m

      matches = eventc.scan(regex)
      if matches.count == 1
        unescape(matches.first.first.strip)
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
