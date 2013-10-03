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

    def leave_footprints(footprintable)
      footprint = ActsAsFootprintable::Footprint.new(:footprintable => footprintable, :footprinter => self)
      if footprint.save
        true
      else
        false
      end
    end

    def access_histories_for(klass, limit=nil)
      get_access_history_records(limit, klass) do
        footprints.for_type(klass).group('footprintable_id').having('MAX(created_at)').pluck(:id)
      end
    end

    def access_histories(limit=nil)
      get_access_history_records(limit) do
        footprints.group('footprintable_id, footprintable_type').having('MAX(created_at)').pluck(:id)
      end
    end

    private
    def get_access_history_records(limit=nil, klass=nil)
      records = footprints.where(:id => yield).order("footprints.created_at desc")
      records = records.includes(klass.table_name.singularize) unless klass.nil?
      records = records.limit(limit) unless limit.nil?
      records.map{|footprint| footprint.footprintable}
    end
  end
end