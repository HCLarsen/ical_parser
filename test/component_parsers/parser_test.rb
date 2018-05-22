require "test_helper"

class ParserTest < Minitest::Test
  include IcalParser::Parser

  def test_parses_tz_params
    params = "TZID=America/New_York"
    hash = {"TZID" => "America/New_York"}
    assert_equal hash, parse_params(params)
  end

  def test_parses_multiple_params
    params = "ROLE=REQ-PARTICIPANT;PARTSTAT=TENTATIVE;CN=Henry Cabot"
    hash = {"ROLE" => "REQ-PARTICIPANT", "PARTSTAT" => "TENTATIVE", "CN" => "Henry Cabot"}
    assert_equal hash, parse_params(params)
  end

  def test_params_parser_not_public
    error = assert_raises do
      IcalParser::Parser.parse_params("TZID=America/New_York")
    end
    assert_equal "undefined method `parse_params' for IcalParser::Parser:Module", error.message
  end
end
