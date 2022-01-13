# coding: utf-8

class NotFootprintable < ActiveRecord::Base
  validates :name, :presence => true
end
