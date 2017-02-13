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
      get_access_history_records(footprints.for_type(klass), limit)
    end

    def access_histories(limit=nil)
      get_access_history_records(footprints, limit)
    end

    private
    def get_access_history_records(target, limit=nil)
      footprints.where(:id => recent_footprint_ids(target, limit)).order("created_at DESC")
    end

    def table_name
      ActsAsFootprintable::Footprint.table_name
    end

    def recent_footprint_ids(target, limit=nil)
      recent_footprints = target.group("#{table_name}.footprintable_id, #{table_name}.footprintable_type").
          select("#{table_name}.footprintable_id, #{table_name}.footprintable_type, MAX(#{table_name}.created_at) AS created_at")
      recent_footprints_conditions = recent_footprints.map{ |recent_footprint| recent_footprint.attributes.select{ |_, v| !v.nil?} }
      return [] if recent_footprints_conditions.first.nil?

      columns = recent_footprints_conditions.first.keys.map{|column| "#{table_name}.#{column}" }.join(',')
      values = recent_footprints_conditions.map { |row|
        "(#{row.values.map{|value| ActiveRecord::Base::sanitize(value)}.join(',')})"
      }.join(',')
      records = footprints.where("(#{columns}) IN (#{values})")
      records = records.order("footprints.created_at desc")
      records = records.limit(limit) unless limit.nil?
      records.pluck(:id)
    end
  end
end