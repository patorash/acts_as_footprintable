# frozen_string_literal: true

require 'minitest/autorun'
require 'active_record'
require 'active_support/testing/time_helpers'
require 'database_cleaner/active_record'
require 'acts_as_footprintable'

Dir["#{Dir.pwd}/test/internal/app/models/*.rb"].sort.each(&method(:require))

ActiveRecord::Base.establish_connection('adapter' => 'sqlite3', 'database' => ':memory:')
ActiveRecord::Schema.define do
  create_table :footprints, force: true do |t|
    t.references :footprintable, polymorphic: true
    t.references :footprinter, polymorphic: true
    t.timestamps null: false
  end

  add_index :footprints, %i[footprintable_id footprintable_type]
  add_index :footprints, %i[footprinter_id footprinter_type]

  create_table :users, force: true do |t|
    t.string :name
  end

  create_table :not_users, force: true do |t|
    t.string :name
  end

  create_table :footprintables, force: true do |t|
    t.string :name
  end

  create_table :second_footprintables, force: true do |t|
    t.string :name
  end

  create_table :not_footprintables, force: true do |t|
    t.string :name
  end
end

DatabaseCleaner.strategy = :transaction

module Minitest
  class Spec
    include ActiveSupport::Testing::TimeHelpers

    before :each do
      DatabaseCleaner.start
    end

    after :each do
      DatabaseCleaner.clean
    end
  end
end
