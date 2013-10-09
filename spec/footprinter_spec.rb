# coding: utf-8
require 'spec_helper'
require 'acts_as_footprintable/footprinter'

describe ActsAsFootprintable::Footprinter do

  it "should not be a footprinter" do
    NotUser.should_not be_footprinter
  end

  it "should be a footprinter" do
    User.should be_footprinter
  end

  describe "ユーザーのアクセス履歴を" do
    before do
      @user = User.create!(:name => "user")
      (1..5).each do |index|
        footprintable = Footprintable.create!(:name => "footprintable#{index}")
        second_footprintable = SecondFootprintable.create!(:name => "second_footprintable#{index}")
        3.times do
          footprintable.leave_footprints @user
          second_footprintable.leave_footprints @user
        end
      end
    end

    context "対象のモデル毎に" do
      it "取得できること" do
        @user.access_histories_for(Footprintable).should have(5).items
        @user.access_histories_for(Footprintable).map{|footprint| footprint.footprintable.name}.should == (1..5).to_a.reverse.map{|index| "footprintable#{index}"}
      end

      it "件数を絞り込めること" do
        @user.access_histories_for(Footprintable, 3).should have(3).items
      end
    end

    context "全てのモデルを通じて" do
      it "取得できること" do
        @user.access_histories.should have(10).items
        @user.access_histories.map{|footprint| footprint.footprintable.name}.should == (1..5).to_a.reverse.inject([]) do |results, index|
          results.push "second_footprintable#{index}"
          results.push "footprintable#{index}"
          results
        end
      end

      it "件数を絞り込める事" do
        @user.access_histories(3).should have(3).items
      end
    end
  end
end
