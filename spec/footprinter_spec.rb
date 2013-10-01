require 'acts_as_footprintable'
require 'spec_helper'

describe ActsAsFootprintable::Footprinter do

  before(:each) do
    clean_database
  end

  it "should not be a footprinter" do
    NotUser.should_not be_footprinter
  end

  it "should be a footprinter" do
    User.should be_footprinter
  end

  #describe 'leave footprints by footprinter' do
  #  before do
  #    @user  = User.create!(:name => 'i can footprint!')
  #    @user2 = User.create!(:name => 'a new person')
  #
  #    @footprintable  = Footprintable.create!(:name => 'a footprinting model')
  #    @footprintable2 = Footprintable.create!(:name => 'a 2nd footprinting model')
  #  end
  #
  #  it "should be leave footprints" do
  #    @footprintable.leave_footprints(@user).should be_true
  #  end
  #end
end