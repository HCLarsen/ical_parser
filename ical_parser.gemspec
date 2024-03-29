
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ical_parser/version"

Gem::Specification.new do |spec|
  spec.name          = "ical_parser"
  spec.version       = IcalParser::VERSION
  spec.authors       = ["Chris Larsen"]
  spec.email         = ["clarsenipod@gmail.com"]

  spec.summary       = "iCalendar Parser"
  spec.description   = "Parses calendar information based on the RFC 5545 specification."
  spec.homepage      = "https://github.com/HCLarsen/ical_parser"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "tzinfo", ">= 1.2.5", "< 2.1.0"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
