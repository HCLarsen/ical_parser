require "test_helper"

class DurationParserTest < Minitest::Test
  include IcalParser

  def test_parses_simple_duration
    durationString = "PT1H"
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

  def test_raises_on_invalid_durations
    durations = ["P15D5H0M20S", "P1H", "15D", "P1Y", "P1M", "P1WT1H"]
    durations.each do |duration|
      error = assert_raises do
        DurationParser.parse(duration)
      end
      assert_equal "Invalid Duration format", error.message
    end
  end
end
