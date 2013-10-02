# coding: utf-8
$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'sqlite3'
require 'timecop'
require 'database_cleaner'
require 'acts_as_footprintable'

RSpec.configure do |config|
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

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

ActiveRecord::Schema.define(:version => 1) do
  create_table :footprints do |t|
    t.references :footprintable, :polymorphic => true
    t.references :footprinter, :polymorphic => true
    t.timestamps
  end

  add_index :footprints, [:footprintable_id, :footprintable_type]
  add_index :footprints, [:footprinter_id, :footprinter_type]

  create_table :users do |t|
    t.string :name
  end

  create_table :not_users do |t|
    t.string :name
  end

  create_table :footprintables do |t|
    t.string :name
  end

  create_table :not_footprintables do |t|
    t.string :name
  end
end

class User < ActiveRecord::Base
  acts_as_footprinter
end

class NotUser < ActiveRecord::Base

end

class Footprintable < ActiveRecord::Base
  acts_as_footprintable
  validates :name, :presence => true
end

class NotFootprintable < ActiveRecord::Base
  validates :name, :presence => true
end
