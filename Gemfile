# coding: utf-8
source 'https://rubygems.org'

# Specify your gem's dependencies in acts_as_footprintable.gemspec
gemspec

rails_version = ENV['RAILS_VERSION'] || 'default'
rails = case rails_version
          when 'master'
            { :github => 'rails/rails' }
          when 'default'
            '~> 3.2.0'
          else
            "~> #{rails_version}"
        end

gem 'rails', rails
group :development do
  if rails_version == 'default' ||
      (Gem::Version.correct?(rails_version) && Gem::Version.new(rails_version) < Gem::Version.new("4.0.0"))
    # rails < 4 needs combustion v0.5.2 (does not work with v0.5.3)
    # An error occurred while loading ./spec/footprinter_spec.rb.
    # Failure/Error: Combustion.initialize! :active_record
    #
    # PG::ConnectionBad:
    #   FATAL:  database "acts_as_footprintable" does not exist
    gem 'combustion', "0.5.2"
  else
    gem 'combustion'
  end
end
