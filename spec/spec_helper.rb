## coding: utf-8
require 'rubygems'
require 'bundler'
require 'active_support/dependencies'

Bundler.require :default, :development

Combustion.initialize! :active_record

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
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
