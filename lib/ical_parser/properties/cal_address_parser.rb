require 'uri'

module IcalParser
  module CalAddressParser
    CN_REGEX = /(?<name>CN=[\w\s]*):(?<uri>MAILTO:[\w\.@]*)/
    FACEBOOK_REGEX = /(?<name>CN=[\w\s]*);(?<status>[\w=]*):(?<uri>https:\/{2}[\w\.@\/]*)/

    def self.parse(string)
      if match = CN_REGEX.match(string)
        uri = match["uri"]
      elsif match = FACEBOOK_REGEX.match(string)
        uri = match["uri"]
      else
        uri  = string
      end
      URI.parse(uri)
    end
  end
end
