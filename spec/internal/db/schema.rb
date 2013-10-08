# coding: utf-8
ActiveRecord::Schema.define do
  create_table :footprints, :force => true do |t|
    t.references :footprintable, :polymorphic => true
    t.references :footprinter, :polymorphic => true
    t.timestamps
  end

  add_index :footprints, [:footprintable_id, :footprintable_type]
  add_index :footprints, [:footprinter_id, :footprinter_type]

  create_table :users, :force => true do |t|
    t.string :name
  end

  create_table :not_users, :force => true do |t|
    t.string :name
  end

  create_table :footprintables, :force => true do |t|
    t.string :name
  end

  create_table :second_footprintables, :force => true do |t|
    t.string :name
  end

  create_table :not_footprintables, :force => true do |t|
    t.string :name
  end
end
