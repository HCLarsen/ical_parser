require "test_helper"

class EventParserTest < Minitest::Test
  include IcalParser

  def setup
    @event_string = <<~HEREDOC
    BEGIN:VEVENT
    UID:MyString1
    DTSTAMP:20180210T163706Z
    DTSTART:20180220T163706Z
    DTEND:20180220T173706Z
    SUMMARY:FirstEvent
    DESCRIPTION:Event description\\, which must be escaped with the \\\\ character.
    END:VEVENT
    HEREDOC
  end

  def test_finds_and_parses_summary
    summary = EventParser.find_text_property(@event_string, "summary")
    assert_equal "FirstEvent", summary
  end
end
