# frozen_string_literal: true

require 'test_helper'
require 'acts_as_footprintable/footprinter'

describe ActsAsFootprintable::Footprinter do

  it "should not be a footprinter" do
    expect(NotUser).wont_be :footprinter?
  end

  it "should be a footprinter" do
    expect(User).must_be :footprinter?
  end

  describe "ユーザーのアクセス履歴を" do
    let(:user_1) { User.create!(name: "user_1") }
    before do
      (1..5).each do |index|
        footprintable = Footprintable.create!(name: "footprintable#{index}")
        second_footprintable = SecondFootprintable.create!(name: "second_footprintable#{index}")
        3.times do
          footprintable.leave_footprints user_1
          second_footprintable.leave_footprints user_1
        end
      end
    end

    describe "対象のモデル毎に" do
      it "取得できること" do
        expect(user_1.access_histories_for(Footprintable).count).must_equal 5
        expect(user_1.access_histories_for(Footprintable).map { |footprint| footprint.footprintable.name }).must_equal (1..5).to_a.reverse.map { |index| "footprintable#{index}" }
      end

      it "件数を絞り込めること" do
        expect(user_1.access_histories_for(Footprintable, 3).count).must_equal 3
        expect(user_1.access_histories_for(Footprintable, 3).map { |footprint| footprint.footprintable.name }).must_equal (3..5).to_a.reverse.map { |index| "footprintable#{index}" }
      end
    end

    describe "全てのモデルを通じて" do
      it "取得できること" do
        expect(user_1.access_histories.count).must_equal 10
        footprintable_names = (1..5).to_a.reverse.inject([]) do |results, index|
          results.push "second_footprintable#{index}"
          results.push "footprintable#{index}"
          results
        end
        expect(user_1.access_histories.map { |footprint| footprint.footprintable.name }).must_equal footprintable_names
      end

      it "件数を絞り込める事" do
        expect(user_1.access_histories(3).count).must_equal 3
      end
    end

    describe 'アクセス履歴のないユーザーの場合' do
      let(:user_2) { User.create!(:name => "user_2") }
      it '件数が0件であること' do
        expect(user_2.access_histories_for(Footprintable).count).must_equal 0
      end
    end
  end
end
