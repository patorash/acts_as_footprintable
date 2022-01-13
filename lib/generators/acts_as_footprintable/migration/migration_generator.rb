# frozen_string_literal: true

require 'rails/generators/migration'

module ActsAsFootprintable
  class MigrationGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    desc 'Generators migration for footprintable(footprints table)'

    def self.orm
      Rails::Generators.options[:rails][:orm]
    end

    def self.source_root
      File.join(File.dirname(__FILE__), 'templates', (orm.to_s unless orm.instance_of?(String)))
    end

    def self.orm_has_migration?
      [:active_record].include? orm
    end

    def self.next_migration_number(_path)
      Time.now.utc.strftime('%Y%m%d%H%M%S')
    end

    def create_migration_file
      return unless self.class.orm_has_migration?

      migration_template 'migration.rb',
                         'db/migrate/acts_as_footprintable_migration.rb',
                         migration_version: migration_version
    end

    def migration_version
      "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]" if over_rails5?
    end

    def over_rails5?
      Rails::VERSION::MAJOR >= 5
    end
  end
end
