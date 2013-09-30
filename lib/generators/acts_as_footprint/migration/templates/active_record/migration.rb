# coding: utf-8
class ActsAsFootprintMigration < ActiveRecord::Migration
  def self.up
    create_table :footprints do |t|
      t.references :target, :polymorphic => true
      t.references :user, :polymorphic => true
      t.timestamps
    end

    if ActiveRecord::VERSION::MAJOR < 4
      add_index :footprints, [:target_id, :target_type]
      add_index :footprints, [:user_id, :user_type]
    end
  end

  def self.down
    drop_table :footprints
  end
end