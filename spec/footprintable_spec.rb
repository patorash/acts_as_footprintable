# coding: utf-8
require 'spec_helper'

describe ActsAsFootprintable::Footprintable do

  it "should not be a footprintable" do
    NotFootprintable.should_not be_footprintable
  end

  it "should be a footprintable" do
    Footprintable.should be_footprintable
  end

  describe 'leave footprints by footprinter' do

    before do
      @user  = User.create!(:name => 'i can footprint!')
      @user2 = User.create!(:name => 'a new person')

      @footprintable  = Footprintable.create!(:name => 'a footprinting model')
      @footprintable2 = Footprintable.create!(:name => 'a 2nd footprinting model')
    end

    it "should be leave footprints" do
      @footprintable.leave_footprints(@user).should be_true
    end

    it "足跡の数が増えていること" do
      expect {
        @footprintable.leave_footprints @user
      }.to change{ @footprintable.footprint_count }.from(0).to(1)
    end

    it "10回アクセスしたら10になること" do
      expect {
        10.times { @footprintable.leave_footprints @user }
      }.to change{ @footprintable.footprint_count }.from(0).to(10)
    end

    it "複数人でアクセスしたら合計されること" do
      expect {
        5.times { @footprintable.leave_footprints @user }
        5.times { @footprintable.leave_footprints @user2 }
      }.to change{ @footprintable.footprint_count }.from(0).to(10)
    end

    describe "期間指定をする" do
      before do
        (1..30).each do |day|
          Timecop.travel(Time.parse("2013/9/#{day}")) do
            5.times {@footprintable.leave_footprints @user}
          end
        end
      end

      context "1週間の場合" do
        it "35の足跡があること" do
          Timecop.travel(Time.parse("2013/9/30 10:00:00")) do
            @footprintable.footprint_count_between(1.week.ago..Time.now).should == 35
          end
        end
      end

      context "1ヶ月の場合" do
        it "150の足跡があること" do
          Timecop.travel(Time.parse("2013/9/30 10:00:00")) do
            @footprintable.footprint_count_between(1.month.ago..Time.now).should == 150
          end
        end
      end
    end
  end

  describe "アクセスランキングを作成" do
    before do
      @user  = User.create!(:name => 'i can footprint!')
    end

    context "件数と期間を制限" do
      before do
        (1..30).each do |index|
          Timecop.travel(Time.parse("2013/9/#{index}")) do
            footprintable = Footprintable.create!(:name => "Footprintable#{index}")
            index.times {footprintable.leave_footprints @user}
          end
        end
      end
      subject do
        month = Time.new(2013,9,1)
        Footprintable.access_ranking(month.beginning_of_month...1.week.since(month), 5)
      end
      it { should == {7 => 7, 6 => 6, 5 => 5, 4 => 4, 3 => 3 }}
      it { should have(5).items }
    end
  end
end