require "test_helper"

class TextParserTest < Minitest::Test
  include IcalParser

  def setup
    @eventc = <<~HEREDOC
    BEGIN:VEVENT
    SUMMARY:Lunchtime meeting
    UID:ff808181-1fd7389e-011f-d7389ef9-00000003
    DTSTART;TZID=America/New_York:20160420T120000
    DURATION:PT1H
    DESCRIPTION: We'll continue with the unfinished business from last time,
     in particular:
       Can names dtstart with a number?
       What if they are all numeric?
       Reuse of names - is it valid
     I remind the attendees we have spent 3 months on these subjects. We need
     closure!!!
    LOCATION:Mo's bar - back room
    END:VEVENT
    HEREDOC
  end

  def test_unescapes_text
    escaped = "I need to escape \\, \\; \\\\ but not \n newline characters"
    text = "I need to escape , ; \\ but not \n newline characters"
    assert_equal text, TextParser.unescape(escaped)
  end

  def test_escapes_text
    text = "I need to escape , ; \\ but not \n newline characters"
    escaped = "I need to escape \\, \\; \\\\ but not \n newline characters"
    assert_equal escaped, TextParser.escape(text)
  end

  def test_parses_text
    description_string = <<~DESCRIPTION_STRING
    We'll continue with the unfinished business from last time,
     in particular:
       Can names dtstart with a number?
       What if they are all numeric?
       Reuse of names - is it valid
     I remind the attendees we have spent 3 months on these subjects. We need
     closure!!!
    DESCRIPTION_STRING

    assert_equal description_string.strip, TextParser.parse("description", @eventc)
  end
end
