require "test_helper"

class CalendarParserTest < Minitest::Test
  include IcalParser::CalendarParser

  def test_unfolds_multi_line_text
    folded_text = <<~FOLDED
    DESCRIPTION:This is a lo
     ng description
      that exists on a long line.
    FOLDED
    unfolded_text = "DESCRIPTION:This is a long description that exists on a long line."
    assert_equal unfolded_text, unfold(folded_text.strip)
  end
end
