require "test_helper"

class DateTimeParserTest < Minitest::Test
  include IcalParser
  
  def test_parses_mailto_cal_address
    address = "mailto:jane_doe@example.com"
    uri = CalAddressParser.parse(address)
    assert_equal "mailto", uri.scheme
    assert_equal "jane_doe@example.com", uri.to
  end

  def test_parses_cal_address_with_contact_name
    address = "CN=John Doe:MAILTO:john.doe@example.com"
    uri = CalAddressParser.parse(address)
    assert_equal "mailto", uri.scheme
    assert_equal "john.doe@example.com", uri.to
  end

  def test_parses_facebook_format_cal_address
    address = "CN=John Doe;PARTSTAT=ACCEPTED:https://www.facebook.com/john.doe"
    uri = CalAddressParser.parse(address)
    assert_equal "https", uri.scheme
    assert_equal "www.facebook.com", uri.host
    assert_equal "/john.doe", uri.path
  end
end
