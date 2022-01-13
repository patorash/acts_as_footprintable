# coding: utf-8

class SecondFootprintable < ActiveRecord::Base
  acts_as_footprintable
  validates :name, :presence => true
end
