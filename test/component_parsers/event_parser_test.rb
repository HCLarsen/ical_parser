require "test_helper"

class EventParserTest < Minitest::Test
  include IcalParser

  def setup
    @eventc = <<~HEREDOC
    BEGIN:VEVENT
    SUMMARY:Lunchtime meeting
    UID:ff808181-1fd7389e-011f-d7389ef9-00000003
    DTSTAMP:20160418T180000Z
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

  def test_finds_and_parses_summary
    summary = EventParser.find_property(@eventc, "summary")
    assert_equal "Lunchtime meeting", summary
  end

  def test_finds_and_parses_multi_line_description
    description_string = <<~DESCRIPTION_STRING
    We'll continue with the unfinished business from last time,
     in particular:
       Can names dtstart with a number?
       What if they are all numeric?
       Reuse of names - is it valid
     I remind the attendees we have spent 3 months on these subjects. We need
     closure!!!
    DESCRIPTION_STRING

    description = EventParser.find_property(@eventc, "description")
    assert_equal description_string.strip, description
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

    summary = EventParser.find_property(eventc, "summary")
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
      summary = EventParser.find_property(eventc, "summary")
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
      summary = EventParser.find_property(eventc, "uid")
    end
    assert_equal "Invalid Event: UID is REQUIRED", error.message
  end

  def test_finds_and_parses_dtstamp
    dtstamp = EventParser.find_property(@eventc, "dtstamp")
    assert_equal Time.utc(2016,4,18,18,0,0), dtstamp
  end

  def test_finds_and_parses_organizer
    eventc = <<~HEREDOC
    BEGIN:VEVENT
    DTSTAMP:19960704T120000Z
    UID:uid1@example.com
    ORGANIZER:mailto:jsmith@example.com
    DTSTART:19960918T143000Z
    DTEND:19960920T220000Z
    STATUS:CONFIRMED
    CATEGORIES:CONFERENCE
    SUMMARY:Networld+Interop Conference
    DESCRIPTION:Networld+Interop Conference
      and Exhibit\nAtlanta World Congress Center\n
     Atlanta\, Georgia
    END:VEVENT
    HEREDOC
    organizer = EventParser.find_property(eventc, "organizer")
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
    DESCRIPTION:Networld+Interop Conference
      and Exhibit\nAtlanta World Congress Center\n
     Atlanta\, Georgia
    END:VEVENT
    HEREDOC
    attendees = EventParser.find_property(eventc, "attendee")
    assert_equal 3, attendees.count
    assert_equal 'jdoe@example.com', attendees.first.to
  end
end
