# frozen_string_literal: true

require 'test_helper'
require 'acts_as_footprintable/footprintable'

describe ActsAsFootprintable::Footprintable do
  it 'should not be a footprintable' do
    expect(NotFootprintable).wont_be :footprintable?
  end

  it 'should be a footprintable' do
    expect(Footprintable).must_be :footprintable?
  end

  describe 'leave footprints by footprinter' do
    let(:user) { User.create!(name: 'i can footprint!') }
    let(:user2) { User.create!(name: 'a new person') }
    let(:footprintable) { Footprintable.create!(name: 'a footprinting model') }
    let(:footprintable2) { Footprintable.create!(name: 'a 2nd footprinting model') }

    it 'should be leave footprints' do
      expect(footprintable.leave_footprints(user)).must_equal true
    end

    it '足跡の数が増えていること' do
      expect(footprintable.footprint_count).must_equal 0
      footprintable.leave_footprints user
      expect(footprintable.footprint_count).must_equal 1
    end

    it '10回アクセスしたら10になること' do
      expect(footprintable.footprint_count).must_equal 0
      10.times { footprintable.leave_footprints user }
      expect(footprintable.footprint_count).must_equal 10
    end

    it '複数人でアクセスしたら合計されること' do
      expect(footprintable.footprint_count).must_equal 0
      5.times { footprintable.leave_footprints user }
      5.times { footprintable.leave_footprints user2 }
      expect(footprintable.footprint_count).must_equal 10
    end

    describe '期間指定をする' do
      before do
        1.upto(30) do |day|
          travel_to Time.parse("2013-09-#{day}") do
            5.times { footprintable.leave_footprints user }
          end
        end
      end

      describe '1週間の場合' do
        it '35の足跡があること' do
          travel_to Time.parse('2013-09-30 10:00:00') do
            expect(footprintable.footprint_count_between(1.week.ago..Time.now)).must_equal 35
          end
        end
      end

      describe '1ヶ月の場合' do
        it '150の足跡があること' do
          travel_to Time.parse('2013-09-30 10:00:00') do
            expect(footprintable.footprint_count_between(1.month.ago..Time.now)).must_equal 150
          end
        end
      end
    end
  end

  describe 'アクセスランキングを作成' do
    let(:user) { User.create!(name: 'i can footprint!') }

    describe '件数と期間を制限' do
      before do
        1.upto(30) do |index|
          travel_to Time.parse("2013-09-#{index}") do
            footprintable = Footprintable.create!(name: "Footprintable#{index}")
            index.times { footprintable.leave_footprints user }
          end
        end
      end
      subject do
        month = Time.new(2013, 9, 1)
        Footprintable.access_ranking(month.beginning_of_month...1.week.since(month), 5)
      end

      it 'アクセスランキングが取得できること' do
        expect(subject).must_equal({ 7 => 7, 6 => 6, 5 => 5, 4 => 4, 3 => 3 })
      end

      it '5件取得できること' do
        expect(subject.count).must_equal 5
      end
    end
  end
end
