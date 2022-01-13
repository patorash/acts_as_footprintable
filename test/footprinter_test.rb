# frozen_string_literal: true

require 'test_helper'
require 'acts_as_footprintable/footprinter'

describe ActsAsFootprintable::Footprinter do
  it 'should not be a footprinter' do
    expect(NotUser).wont_be :footprinter?
  end

  it 'should be a footprinter' do
    expect(User).must_be :footprinter?
  end

  describe 'ユーザーのアクセス履歴を' do
    let(:user1) { User.create!(name: 'user1') }
    before do
      1.upto(5) do |index|
        footprintable = Footprintable.create!(name: "footprintable#{index}")
        second_footprintable = SecondFootprintable.create!(name: "second_footprintable#{index}")
        3.times do
          footprintable.leave_footprints user1
          second_footprintable.leave_footprints user1
        end
      end
    end

    describe '対象のモデル毎に' do
      it '取得できること' do
        expect(user1.access_histories_for(Footprintable).count).must_equal 5
        expected_data = 5.downto(1).map { |i| "footprintable#{i}" }
        expect(user1.access_histories_for(Footprintable).map(&:footprintable).pluck(:name)).must_equal expected_data
      end

      it '件数を絞り込めること' do
        expect(user1.access_histories_for(Footprintable, 3).count).must_equal 3
        expected_data = 5.downto(3).map { |i| "footprintable#{i}" }
        expect(user1.access_histories_for(Footprintable, 3).map(&:footprintable).pluck(:name)).must_equal expected_data
      end
    end

    describe '全てのモデルを通じて' do
      it '取得できること' do
        expect(user1.access_histories.count).must_equal 10
        footprintable_names = 5.downto(1).each_with_object([]) do |index, results|
          results.push "second_footprintable#{index}"
          results.push "footprintable#{index}"
        end
        expect(user1.access_histories.map(&:footprintable).pluck(:name)).must_equal footprintable_names
      end

      it '件数を絞り込める事' do
        expect(user1.access_histories(3).count).must_equal 3
      end
    end

    describe 'アクセス履歴のないユーザーの場合' do
      let(:user2) { User.create!(name: 'user2') }
      it '件数が0件であること' do
        expect(user2.access_histories_for(Footprintable).count).must_equal 0
      end
    end
  end
end
