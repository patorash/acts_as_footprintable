# frozen_string_literal: true

module ActsAsFootprintable
  module Footprinter
    def self.included(base)
      base.class_eval do
        has_many :footprints, class_name: 'ActsAsFootprintable::Footprint', as: :footprinter, dependent: :destroy do
          def footprintable
            includes(:footprintable).map(&:footprintable)
          end
        end
      end
    end

    def leave_footprints(footprintable)
      footprint = ActsAsFootprintable::Footprint.new(footprintable: footprintable, footprinter: self)
      footprint.save
    end

    def access_histories_for(klass, limit = nil)
      get_access_history_records(footprints.for_type(klass), limit)
    end

    def access_histories(limit = nil)
      get_access_history_records(footprints, limit)
    end

    private

    def get_access_history_records(target, limit = nil)
      footprints.where(id: recent_footprint_ids(target, limit)).order("created_at DESC")
    end

    def table_name
      ActsAsFootprintable::Footprint.table_name
    end

    def recent_footprint_ids(target, limit = nil)
      recent_footprints = target.group("#{table_name}.footprintable_id, #{table_name}.footprintable_type")
                                .select("#{table_name}.footprintable_id, #{table_name}.footprintable_type, MAX(#{table_name}.created_at) AS created_at")
      records = footprints.where("(#{table_name}.footprintable_id, #{table_name}.footprintable_type, #{table_name}.created_at) IN (#{recent_footprints.to_sql})")
      records = records.order("footprints.created_at desc")
      records = records.limit(limit) unless limit.nil?
      records.pluck(:id)
    end
  end
end
