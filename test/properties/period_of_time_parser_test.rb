require "test_helper"

class PeriodOfTimeParserTest < Minitest::Test
  include IcalParser

  def setup
    @parser = PeriodOfTimeParser.parser
  end

  def test_parses_start_end_format
    string = "19970101T180000Z/19970102T070000Z"
    period = @parser.parse(string)
    start = Time.utc(1997, 1, 1, 18, 0, 0)
    finish = Time.utc(1997, 1, 2, 7, 0, 0)
    #assert_equal start, period.start_time
    #assert_equal finish, period.end_time
    #assert_equal finish - start, period.duration
  end
end
