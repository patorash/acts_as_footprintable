# coding: utf-8
module ActsAsFootprintable
  class Footprint < ::ActiveRecord::Base
    if ::ActiveRecord::VERSION::MAJOR < 4
      attr_accessible :footprintable_id, :footprintable_type,
                      :footprinter_id,  :footprinter_type,
                      :footprintable, :footprinter
    end

    belongs_to :footprintable, :polymorphic => true
    belongs_to :footprinter, :polymorphic => true

    scope :for_type, lambda{|klass| where(:footprintable_type => klass.name)}
    scope :by_type,  lambda{|klass| where(:footprinter_type   => klass.name)}

    validates :footprintable_id, :presence => true
    validates :footprinter_id, :presence => true
  end
end