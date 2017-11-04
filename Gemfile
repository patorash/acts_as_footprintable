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

combustion = case rails
               when '~> 3.2.0'
                 '~> 0.3.3'
               else
                 '~> 0.5'
             end
group :development do
  gem 'combustion', combustion
end
