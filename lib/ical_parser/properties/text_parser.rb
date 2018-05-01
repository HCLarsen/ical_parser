module IcalParser
  class TextParser
    def self.parse(string)
      string.gsub(/(\\(?!\\))/){ |match| "" }
    end
  end
end
