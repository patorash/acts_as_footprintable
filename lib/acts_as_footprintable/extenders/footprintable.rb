# frozen_string_literal: true

module ActsAsFootprintable
  module Extenders
    module Footprintable
      def footprintable?
        false
      end

      def acts_as_footprintable
        require 'acts_as_footprintable/footprintable'
        include ActsAsFootprintable::Footprintable

        class_eval do
          def self.footprintable?
            true
          end

          def self.access_ranking(range=nil, limit=nil)
            records = Footprint.for_type(self)
            records = records.where(:created_at => range) unless range.nil?
            records = records.limit(limit) unless limit.nil?
            records.group(:footprintable_id).order('count_footprintable_id desc').count(:footprintable_id)
          end
        end
      end
    end
  end
end