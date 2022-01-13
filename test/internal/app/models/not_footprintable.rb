# frozen_string_literal: true

class NotFootprintable < ActiveRecord::Base
  validates :name, presence: true
end
