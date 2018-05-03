require "test_helper"

class DateTimeParserTest < Minitest::Test
  include IcalParser

  def test_parses_UTC_date_time
    dateTime = DateTimeParser.parse("19980119T070000Z")
    assert_equal Time.utc(1998, 1, 19, 7, 0, 0), dateTime
  end

  def test_parses_floating_date_time
    dateTime = DateTimeParser.parse("19980119T070000")
    assert_equal Time.local(1998, 1, 19, 7, 0, 0), dateTime
  end

  # Note: I intentionally created tests for multiple time zones, since tests that pass in
  # the tester's local time zone might not pass in other time zones.
  def test_identifies_time_with_EST_timezone
    dateTime = DateTimeParser.parse("TZID=Canada/Eastern:19980119T020000")
    assert_equal Time.new(1998, 1, 19, 2, 0, 0, "-05:00"), dateTime
  end

  def test_identifies_time_with_EDT_timezone
    dateTime = DateTimeParser.parse("TZID=Canada/Eastern:19980719T020000")
    assert_equal Time.new(1998, 7, 19, 2, 0, 0, "-04:00"), dateTime
  end

  def test_identifies_time_with_PST_timezone
    dateTime = DateTimeParser.parse("TZID=Canada/Pacific:19980119T020000")
    assert_equal Time.new(1998, 1, 19, 5, 0, 0, "-05:00"), dateTime
  end
end
