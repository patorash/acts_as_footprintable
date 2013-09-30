require 'acts_as_footprintable'
require 'spec_helper'

describe ActsAsFootprintable::Footprinter do

  before(:each) do
    clean_database
  end

  it "should not be a footprinter" do
    NotUser.should_not be_footprintable
  end

  it "should be a footprinter" do
    User.should be_footprintable
  end
end