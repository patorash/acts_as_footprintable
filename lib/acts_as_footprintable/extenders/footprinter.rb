# frozen_string_literal: true

module ActsAsFootprintable
  module Extenders
    module Footprinter
      def footprinter?
        false
      end

      def acts_as_footprinter(*args)
        require 'acts_as_footprintable/footprinter'
        include ActsAsFootprintable::Footprinter

        class_eval do
          def self.footprinter?
            true
          end
        end
      end
    end
  end
end