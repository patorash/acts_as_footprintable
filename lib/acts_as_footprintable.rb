require 'active_record'
require 'active_support/inflector'

module ActsAsFootprintable
  if defined?(ActiveRecord::Base)
    require 'acts_as_footprintable/extenders/footprintable'
    require 'acts_as_footprintable/extenders/footprinter'
    require 'acts_as_footprintable/footprint'
    ActiveRecord::Base.extend ActsAsFootprintable::Extenders::Footprintable
    ActiveRecord::Base.extend ActsAsFootprintable::Extenders::Footprinter
  end
end
