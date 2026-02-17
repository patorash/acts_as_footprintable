# frozen_string_literal: true

require 'English'
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acts_as_footprintable/version'

Gem::Specification.new do |spec|
  spec.name          = 'acts_as_footprintable'
  spec.version       = ActsAsFootprintable::VERSION
  spec.author        = 'Toyoaki Oko'
  spec.email         = 'chariderpato@gmail.com'
  spec.description   = 'Rails gem to allowing records to leave footprints'
  spec.summary       = 'Rails gem to allowing records to leave footprints'
  spec.homepage      = 'https://github.com/patorash/acts_as_footprintable'
  spec.license       = 'MIT'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.6'

  spec.add_dependency 'activerecord', '< 8.2.0', '>= 5.2.0'
  spec.add_development_dependency 'concurrent-ruby', '1.3.4'
  spec.add_development_dependency 'database_cleaner', '< 3.0', '>= 1.99.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rubocop', '~> 1.24'
  spec.add_development_dependency 'rubocop-minitest', '~> 0.17'
  spec.add_development_dependency 'rubocop-performance', '~> 1.13'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6'
  spec.add_development_dependency 'sqlite3', '< 3.0', '>= 1.3'
  spec.add_development_dependency 'mutex_m', '~> 0.1'
  spec.add_development_dependency 'bigdecimal', '~> 3.0'
  spec.add_development_dependency 'base64', '~> 0.1'
  spec.add_development_dependency 'logger', '~> 1.0'
  spec.add_development_dependency 'benchmark', '~> 0.1'
end
