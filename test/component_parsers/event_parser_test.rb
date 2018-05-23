require "test_helper"

class EventParserTest < Minitest::Test
  include IcalParser::EventParser

  def setup
    @eventc = <<~HEREDOC
    BEGIN:VEVENT
    DTSTAMP:19960704T120000Z
    UID:uid1@example.com
    ORGANIZER:mailto:jsmith@example.com
    DTSTART:19960918T143000Z
    DTEND:19960920T220000Z
    STATUS:CONFIRMED
    CATEGORIES:CONFERENCE
    SUMMARY:Networld+Interop Conference
    DESCRIPTION:Networld+Interop Conference and Exhibit\nAtlanta World Congress Center\nAtlanta\, Georgia
    END:VEVENT
    HEREDOC
  end

  def test_unfolds_multi_line_text
    folded_text = <<~FOLDED
    DESCRIPTION:This is a lo
     ng description
      that exists on a long line.
    FOLDED
    unfolded_text = "DESCRIPTION:This is a long description that exists on a long line."
    assert_equal unfolded_text, unfold(folded_text.strip)
  end

  def test_finds_and_parses_summary
    summary = find_property(@eventc, "summary")
    assert_equal "Networld+Interop Conference", summary
  end

  def test_does_not_raise_on_no_summary
    eventc = <<~HEREDOC
    BEGIN:VEVENT
    UID:MyString1
    DTSTAMP:20180210T163706Z
    DTSTART:20180220T163706Z
    DTEND:20180220T173706Z
    DESCRIPTION:Event description\\, which must be escaped with the \\\\ character.
    END:VEVENT
    HEREDOC

    summary = find_property(eventc, "summary")
    assert_nil summary
  end

  def test_raises_on_more_than_one_summary
    eventc = <<~HEREDOC
    BEGIN:VEVENT
    UID:MyString1
    DTSTAMP:20180210T163706Z
    DTSTART:20180220T163706Z
    DTEND:20180220T173706Z
    SUMMARY:FirstEvent
    SUMMARY:FirstEvent
    DESCRIPTION:Event description\\, which must be escaped with the \\\\ character.
    END:VEVENT
    HEREDOC

    error = assert_raises do
      summary = find_property(eventc, "summary")
    end
    assert_equal "Invalid Event: SUMMARY MUST NOT occur more than once", error.message
  end

  def test_raises_on_no_uid
    eventc = <<~HEREDOC
    BEGIN:VEVENT
    DTSTAMP:20180210T163706Z
    DTSTART:20180220T163706Z
    DTEND:20180220T173706Z
    SUMMARY:FirstEvent
    DESCRIPTION:Event description\\, which must be escaped with the \\\\ character.
    END:VEVENT
    HEREDOC

    error = assert_raises do
      summary = find_property(eventc, "uid")
    end
    assert_equal "Invalid Event: UID is REQUIRED", error.message
  end

  def test_finds_and_parses_dtstamp
    dtstamp = find_property(@eventc, "dtstamp")
    assert_equal Time.utc(1996,7,4,12,0,0), dtstamp
  end

  def test_finds_and_parses_organizer
    organizer = find_property(@eventc, "organizer")
    assert_equal "mailto", organizer.scheme
    assert_equal "jsmith@example.com", organizer.to
  end

  def test_finds_and_parses_multiple_attendees
    eventc = <<~HEREDOC
    BEGIN:VEVENT
    DTSTAMP:19960704T120000Z
    UID:uid1@example.com
    ORGANIZER:mailto:jsmith@example.com
    ATTENDEE:mailto:jdoe@example.com
    ATTENDEE:mailto:jimdo@example.com
    ATTENDEE:mailto:john_public@example.com
    DTSTART:19960918T143000Z
    DTEND:19960920T220000Z
    STATUS:CONFIRMED
    CATEGORIES:CONFERENCE
    SUMMARY:Networld+Interop Conference
    DESCRIPTION:Networld+Interop Conference and Exhibit\nAtlanta World Congress Center\nAtlanta\, Georgia
    END:VEVENT
    HEREDOC
    attendees = find_property(eventc, "attendee")
    assert_equal 3, attendees.count
    assert_equal 'jdoe@example.com', attendees.first.to
  end

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
end
