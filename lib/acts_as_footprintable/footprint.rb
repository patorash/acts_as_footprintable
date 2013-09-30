# coding: utf-8
module ActsAsFootprintable
  class Footprint < ::ActiveRecord::Base
    if ::ActiveRecord::VERSION::MAJOR < 4
      attr_accessible :footprinable_id, :footprinable_type,
                      :footprinter_id,  :footprinter_type
    end

    belongs_to :footprintable, :polymorphic => true
    belongs_to :footprinter, :polymorphic => true

    scope :for_type, lambda{|klass| where(:footprintable_type => klass)}
    scope :by_type,  lambda{|klass| where(:footprinter_type   => klass)}

    validates :footprinable_id, :presence => true
    validates :footprinter_id, :presence => true
  end
end