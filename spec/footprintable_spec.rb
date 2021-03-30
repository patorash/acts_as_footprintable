RSpec.describe ActsAsFootprintable::Footprintable, type: :model do

  it "should not be a footprintable" do
    expect(NotFootprintable).not_to be_footprintable
  end

  it "should be a footprintable" do
    expect(Footprintable).to be_footprintable
  end

  describe 'leave footprints by footprinter' do
    let(:user) { User.create!(:name => 'i can footprint!') }
    let(:user2) { User.create!(:name => 'a new person') }
    let(:footprintable) { Footprintable.create!(:name => 'a footprinting model') }
    let(:footprintable2) { Footprintable.create!(:name => 'a 2nd footprinting model') }

    it "should be leave footprints" do
      expect(footprintable.leave_footprints(user)).to be_truthy
    end

    it "足跡の数が増えていること" do
      expect {
        footprintable.leave_footprints user
      }.to change { footprintable.footprint_count }.from(0).to(1)
    end

    it "10回アクセスしたら10になること" do
      expect {
        10.times { footprintable.leave_footprints user }
      }.to change { footprintable.footprint_count }.from(0).to(10)
    end

    it "複数人でアクセスしたら合計されること" do
      expect {
        5.times { footprintable.leave_footprints user }
        5.times { footprintable.leave_footprints user2 }
      }.to change { footprintable.footprint_count }.from(0).to(10)
    end

    describe "期間指定をする" do
      before do
        (1..30).each do |day|
          Timecop.travel(Time.parse("2013-09-#{day}")) do
            5.times { footprintable.leave_footprints user }
          end
        end
      end

      context "1週間の場合" do
        it "35の足跡があること" do
          Timecop.travel(Time.parse("2013-09-30 10:00:00")) do
            expect(footprintable.footprint_count_between(1.week.ago..Time.now)).to eq 35
          end
        end
      end

      context "1ヶ月の場合" do
        it "150の足跡があること" do
          Timecop.travel(Time.parse("2013-09-30 10:00:00")) do
            expect(footprintable.footprint_count_between(1.month.ago..Time.now)).to eq 150
          end
        end
      end
    end
  end

  describe "アクセスランキングを作成" do
    let(:user) { User.create!(:name => 'i can footprint!') }

    context "件数と期間を制限" do
      before do
        (1..30).each do |index|
          Timecop.travel(Time.parse("2013-09-#{index}")) do
            footprintable = Footprintable.create!(:name => "Footprintable#{index}")
            index.times { footprintable.leave_footprints user }
          end
        end
      end
      subject do
        month = Time.new(2013, 9, 1)
        Footprintable.access_ranking(month.beginning_of_month...1.week.since(month), 5)
      end
      it { is_expected.to eq ({ 7 => 7, 6 => 6, 5 => 5, 4 => 4, 3 => 3 }) }
      it '5件取得できること' do
        expect(subject.count).to eq 5
      end
    end
  end
end