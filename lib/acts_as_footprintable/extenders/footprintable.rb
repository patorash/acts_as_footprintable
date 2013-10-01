# coding: utf-8
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
        end
      end
    end
  end
end