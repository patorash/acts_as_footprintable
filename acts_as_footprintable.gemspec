# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acts_as_footprintable/version'

Gem::Specification.new do |spec|
  spec.name          = "acts_as_footprintable"
  spec.version       = ActsAsFootprintable::VERSION
  spec.author        = "Toyoaki Oko"
  spec.email         = "chariderpato@gmail.com"
  spec.description   = %q{Rails gem to allowing records to leave footprints}
  spec.summary       = %q{Rails gem to allowing records to leave footprints}
  spec.homepage      = "https://github.com/patorash/acts_as_footprintable"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'timecop', '~> 0'
  spec.add_development_dependency 'database_cleaner', '~> 2.0'
end
