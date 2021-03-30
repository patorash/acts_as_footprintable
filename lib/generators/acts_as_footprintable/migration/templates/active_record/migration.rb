class ActsAsFootprintableMigration < ActiveRecord::Migration<%= migration_version %>
  def self.up
    create_table :footprints do |t|
      t.references :footprintable, polymorphic: true
      t.references :footprinter, polymorphic: true
      t.timestamps null: false
    end

    if ActiveRecord::VERSION::MAJOR < 4
      add_index :footprints, [:footprintable_id, :footprintable_type]
      add_index :footprints, [:footprinter_id, :footprinter_type]
    end
  end

  def self.down
    drop_table :footprints
  end
end