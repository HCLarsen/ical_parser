require "test_helper"

class DateParserTest < Minitest::Test
  include IcalParser

  def test_parses_date
    date = "19970714"
    assert_equal Date.new(1997,7,14), DateParser.parse(date)
  end
end
