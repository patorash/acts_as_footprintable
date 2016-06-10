## coding: utf-8
require 'rubygems'
require 'bundler/setup'
require 'combustion'
require 'database_cleaner'
require 'timecop'

Combustion.initialize! :active_record

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.before :suite do
    DatabaseCleaner.strategy = :truncation
  end
  config.before :each do
    DatabaseCleaner.start
  end
  config.after :each do
    DatabaseCleaner.clean
  end
end
