require "test_helper"

class TimeParserTest < Minitest::Test
  include IcalParser

  def setup
    @now = Time.now
  end

  def test_parses_UTC_time
    time = TimeParser.parse("070000Z", @now)
    assert_equal Time.utc(@now.year, @now.month, @now.day, 7, 0, 0), time
  end

  def test_parses_local_time
    time = TimeParser.parse("230000", @now)
    assert_equal Time.local(@now.year, @now.month, @now.day, 23, 0, 0), time
  end

  def test_identifies_time_with_EST_timezone
    @now = Time.local(2018, 01, 19)
    time = TimeParser.parse("TZID=Canada/Eastern:083000", @now)
    assert_equal Time.new(@now.year, @now.month, @now.day, 8, 30, 0, "-05:00"), time
  end

  def test_identifies_time_with_EDT_timezone
    @now = Time.local(2018, 05, 15)
    time = TimeParser.parse("TZID=Canada/Eastern:070000", @now)
    assert_equal Time.new(@now.year, @now.month, @now.day, 7, 0, 0, "-04:00"), time
  end

  def test_identifies_time_with_PST_timezone
    @now = Time.local(2018, 01, 19)
    time = TimeParser.parse("TZID=Canada/Pacific:020000", @now)
    assert_equal Time.new(@now.year, @now.month, @now.day, 2, 0, 0, "-08:00"), time
  end

  def test_raises_on_invalid_date_time_format
    error = assert_raises do
      TimeParser.parse("230000-0800")
    end
    assert_equal "Invalid Time format", error.message
  end
end
