require "test_helper"

class FloatParserTest < Minitest::Test
  include IcalParser

  def test_parses_large_float
    string = "1000000.0000001"
    float = 1000000.0000001
    assert_equal float, FloatParser.parse(string)
  end

  def test_parses_small_float
    string = "1.333"
    float = 1.333
    assert_equal float, FloatParser.parse(string)
  end

  def test_parses_negative_pi
    string = "-3.14"
    float = -3.14
    assert_equal float, FloatParser.parse(string)
  end
end
