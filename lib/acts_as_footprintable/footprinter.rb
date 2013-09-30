# coding: utf-8
module ActsAsFootprintable
  module Footprinter
    def self.included(base)
      base.class_eval do
        has_many :footprints, :class_name => 'ActsAsFootprint::Footprint', :as => :footprinter, :dependent => :destroy do
          def footprintable
            includes(:footprintable).map(&:footprintable)
          end
        end
      end
    end
  end

  def footprint(args)
    args[:footprintable].footprint args.merge({:footprinter => self})
  end
end