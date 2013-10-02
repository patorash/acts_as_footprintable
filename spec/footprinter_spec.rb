require 'acts_as_footprintable'
require 'spec_helper'

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
        3.times { footprintable.leave_footprints @user }
      end
    end

    context "対象のモデル毎に" do
      it "取得できること" do
        @user.access_histories_for(Footprintable).should have(5).items
        @user.access_histories_for(Footprintable).map{|footprintable| footprintable.name}.should == (1..5).to_a.reverse.map{|index| "footprintable#{index}"}
      end

      it "件数を絞り込めること" do
        @user.access_histories_for(Footprintable, 3).should have(3).items
      end
    end

    context "全てのモデルを通じて" do
      it "取得できること"
    end
  end
end
