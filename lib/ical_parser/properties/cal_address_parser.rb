require 'uri'

module IcalParser
  module CalAddressParser
    def self.parse(string)
      /(?<uri>(MAILTO|mailto|https):\/{0,2}[\w\.@\/]*)/ =~ string
      URI.parse(uri)
    end
  end
end
