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

    def footprints
      Footprint.for_type(self.class).where(:footprintable_id => self).count
    end

    def footprints_between(range)
      Footprint.for_type(self.class).where(
          :footprintable_id => self,
          :created_at => range
      ).count
    end
  end
end
