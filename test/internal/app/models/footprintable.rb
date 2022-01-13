# coding: utf-8

class Footprintable < ActiveRecord::Base
  acts_as_footprintable
  validates :name, :presence => true
end
