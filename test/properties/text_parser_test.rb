require "test_helper"

class TextParserTest < Minitest::Test

  include IcalParser

  def test_parses_escaped_text
    escaped = "I need to escape \\, \\; \\\\ but not \n newline characters"
    text = "I need to escape , ; \\ but not \n newline characters"
    assert_equal text, TextParser.parse(escaped)
  end
end
