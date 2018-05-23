module IcalParser
  module CalendarParser
    def unfold(string)
      string.gsub(/\R\s/, "")
    end    
  end
end
