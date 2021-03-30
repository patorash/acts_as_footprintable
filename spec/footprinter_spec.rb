require 'acts_as_footprintable/footprinter'

RSpec.describe ActsAsFootprintable::Footprinter, type: :model do

  it "should not be a footprinter" do
    expect(NotUser).not_to be_footprinter
  end

  it "should be a footprinter" do
    expect(User).to be_footprinter
  end

  describe "ユーザーのアクセス履歴を" do
    let!(:user_1) { User.create!(name: "user_1") }
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

    context "対象のモデル毎に" do
      it "取得できること" do
        expect(user_1.access_histories_for(Footprintable).count).to eq 5
        expect(user_1.access_histories_for(Footprintable).map { |footprint| footprint.footprintable.name }).to eq (1..5).to_a.reverse.map { |index| "footprintable#{index}" }
      end

      it "件数を絞り込めること" do
        expect(user_1.access_histories_for(Footprintable, 3).count).to eq 3
        expect(user_1.access_histories_for(Footprintable, 3).map { |footprint| footprint.footprintable.name }).to eq (3..5).to_a.reverse.map { |index| "footprintable#{index}" }
      end
    end

    context "全てのモデルを通じて" do
      it "取得できること" do
        expect(user_1.access_histories.count).to eq 10
        footprintable_names = (1..5).to_a.reverse.inject([]) do |results, index|
          results.push "second_footprintable#{index}"
          results.push "footprintable#{index}"
          results
        end
        expect(user_1.access_histories.map { |footprint| footprint.footprintable.name }).to eq footprintable_names
      end

      it "件数を絞り込める事" do
        expect(user_1.access_histories(3).count).to eq 3
      end
    end

    context 'アクセス履歴のないユーザーの場合' do
      let!(:user_2) { User.create!(:name => "user_2") }
      it '件数が0件であること' do
        expect(user_2.access_histories_for(Footprintable).count).to eq 0
      end
    end
  end
end
