require "test_helper"

class DateTimeParserTest < Minitest::Test
  include IcalParser

  def test_identifies_and_parses_utc_date_time
    dateTime = DateOrDateTimeParser.parse("19980119T070000Z")
    assert_equal Time.utc(1998, 1, 19, 7, 0, 0), dateTime
  end

  def test_identifies_and_parses_floating_date_time
    dateTime = DateTimeParser.parse("19980119T070000")
    assert_equal Time.local(1998, 1, 19, 7, 0, 0), dateTime
  end

  def test_identifies_and_parses_time_with_EST_timezone
    dateTime = DateTimeParser.parse("TZID=Canada/Eastern:19980119T020000")
    assert_equal Time.new(1998, 1, 19, 2, 0, 0, "-05:00"), dateTime
  end

  def test_identifies_and_parses_date
    date = DateOrDateTimeParser.parse("VALUE=DATE:19971102")
    assert_equal Date.new(1997,11,2), date
  end
end
