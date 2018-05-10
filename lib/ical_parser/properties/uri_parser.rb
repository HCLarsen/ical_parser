require 'uri'

module IcalParser
  module URIParser
    def self.parse(string)
      #components = string.split(/:\/{0,2}/)
      #{ "scheme" => components[0], "hier-part" => components[1] }
      URI.parse(string)
    end
  end
end
