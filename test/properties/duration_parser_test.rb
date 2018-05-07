require "test_helper"

class DurationParserTest < Minitest::Test
  include IcalParser

  def test_parses_simple_duration
    durationString = "P1H"
    assert_equal 3600, DurationParser.parse(durationString)
  end

  def test_parses_duration_with_multiple_elements
    durationString = "P15DT5H0M20S"
    assert_equal 15 * 86400 + 5 * 3600 + 20, DurationParser.parse(durationString)
  end

  def test_parses_weeklong_duration
    durationString = "P7W"
    assert_equal 7 * 604800, DurationParser.parse(durationString)
  end

  def test_parses_negative_duration
    durationString = "-PT15M"
    assert_equal -15 * 60, DurationParser.parse(durationString)
  end
end
