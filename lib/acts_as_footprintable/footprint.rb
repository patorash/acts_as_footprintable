# frozen_string_literal: true

module ActsAsFootprintable
  class Footprint < ::ActiveRecord::Base
    belongs_to :footprintable, polymorphic: true
    belongs_to :footprinter, polymorphic: true

    scope :for_type, lambda{|klass| where(footprintable_type: klass.name)}
    scope :by_type,  lambda{|klass| where(footprinter_type: klass.name)}

    validates :footprintable_id, presence: true
    validates :footprinter_id, presence: true
  end
end