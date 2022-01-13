# frozen_string_literal: true

class Footprintable < ActiveRecord::Base
  acts_as_footprintable
  validates :name, presence: true
end
