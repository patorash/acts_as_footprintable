# coding: utf-8
module ActsAsFootprintable
  module Footprinter
    def self.included(base)
      base.class_eval do
        has_many :footprints, :class_name => 'ActsAsFootprintable::Footprint', :as => :footprinter, :dependent => :destroy do
          def footprintable
            includes(:footprintable).map(&:footprintable)
          end
        end
      end
    end

    def footprint(args)
      args[:footprintable].footprint args.merge({:footprinter => self})
    end

    def access_histories_for(klass, limit=nil)
      records = footprints.for_type(klass).
          includes(klass.table_name.singularize).
          order("footprints.created_at desc").select("DISTINCT footprintable_id, footprintable_type")
      records = records.limit(limit) unless limit.nil?
      records.map{|footprint| footprint.footprintable}
    end
  end
end