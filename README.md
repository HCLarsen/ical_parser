# ICalParser

Ruby parser for the iCalendar RFC 5545 specification. The parser will both parse events from the specification, as well as generate iCalendar compliant output.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ical_parser'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ical_parser

## Usage

### Parsing

The ICSStream.read method will read an ICS stream either from a local file, or a remote address. To read a local file, pass in a string of the local filename and path.

```crystal
filename = File.join(File.dirname(__FILE__), "files", "FIFA_World_Cup_2018.ics")
calendar = ICSStream.read(filename)
calendar.class  #=> Calendar
```

In the case of a remote stream, pass in a URI object with the address of the stream.

```crystal
address = "https://people.trentu.ca/rloney/files/Canada_Holidays.ics"
uri = URI.parse(address)
calendar = ICSStream.read(uri)  #=> #<IcalParser::Calendar:0x10868a5c0>
calendar.class  #=> Calendar
```
In most cases, an iCalendar stream will only contain one calendar object. However, the specification does allow for multiple calendar objects to be sequentially grouped in a single stream. If you are reading such a stream, the ICSStream.read method will only return the first calendar object. If you are working with a stream that may have multiple calendar objects, it's best to use the ICSStream#read_calendars method instead to get an array of Calendar objects.

```crystal
filename = File.join(File.dirname(__FILE__), "files", "FIFA_World_Cup_2018.ics")
calendars = ICSStream.read_calendars(filename)  #=> [#<IcalParser::Calendar:0x10e733100]
calendars.class  #=> Array(Calendar)
```

### Calendar Object & Components

The Calendar class serves as a container for both the calendar properties and the calendar components. The standard calendar components, EVENT, TODO and so forth are accessed as arrays from the calendar object.

```ruby
calendar.events       #=> [#<IcalParser::Event:0x102776f20...]
calendar.events.first #=> #<IcalParser::Event:0x102776f20>
```

For both the calendar object and calendar components, standard properties are accessed directly by the name of the property. These methods have names that correspond directly to the name of the property in the RFC5545 specification, with two exceptions. The first being the CLASS property, which is referred to as classification, to avoid conflicting with the Object#class method. The second is any property that may occur more than once in the component, in which case the accessor is the pluralized version of the property name.

```ruby
# After parsing this event:
# BEGIN:VEVENT
# UID:19970901T130000Z-123401@example.com
# DTSTAMP:19970901T130000Z
# DTSTART:19970903T163000Z
# DTEND:19970903T190000Z
# SUMMARY:Annual Employee Review
# CLASS:PRIVATE
# CATEGORIES:BUSINESS,HUMAN RESOURCES
# END:VEVENT

event.summary         #=> "Annual Employee Review"
event.classification  #=> "PRIVATE"
event.class           #=> IcalParser::Event
event.categories      #=> ["BUSINESS", "HUMAN RESOURCES"]
```

Non-standard and IANA properties are accessed by hash notation.

```ruby
# After these lines are parsed:
# DRESSCODE:CASUAL
# NON-SMOKING;VALUE=BOOLEAN:TRUE

event["DRESSCODE"]  #=> "CASUAL"
event["NON-SMOKING"]  #=> True
```

### Values

Where possible, property values are returned as the corresponding Ruby core data type. TEXT values are returned as Strings, Date, Time and Date-Times are returned as Time, and so forth.

For values that don't have a corresponding Ruby core class, those types are provided by this module. These include CalAddress, Duration, PeriodOfTime and Recur.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/HCLarsen/ical_parser.
