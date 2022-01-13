# frozen_string_literal: true

class SecondFootprintable < ActiveRecord::Base
  acts_as_footprintable
  validates :name, presence: true
end
