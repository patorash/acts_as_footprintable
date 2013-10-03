# coding: utf-8
module ActsAsFootprintable
  module Footprintable

    def self.included(base)
      base.class_eval do
        has_many :footprints, :class_name => 'ActsAsFootprintable::Footprint', :as => :footprintable, :dependent => :destroy do
          def footprinters
            includes(:footprinter).map(&:footprinter)
          end
        end
      end
    end

    def leave_footprints(footprinter)
      footprint = ActsAsFootprintable::Footprint.new(:footprintable => self, :footprinter => footprinter)
      if footprint.save
        true
      else
        false
      end
    end

    def footprint_count
      footprints.count
    end

    def footprint_count_between(range)
      footprints.where(:created_at => range).count
    end
  end
end
