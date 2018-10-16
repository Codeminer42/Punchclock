require 'rails_helper'

RSpec.describe HolidaysService do
  describe "#from_office" do
    subject { described_class.new(office) }

    context "with only regionals holidays" do
      let(:office) { create(:office, :with_holiday) }

      before do
        from = 1.year.ago.to_date
        to = DateTime.current
        allow(Holidays).to receive(:between).with(from, to, :br, :informal).and_return([])
      end

      it "returns regional holidays" do
        day = office.regional_holidays.first.day
        month = office.regional_holidays.first.month
        expect(subject.from_office).to include(month: month, day: day)
      end
    end

    context "with only nationals holidays" do
      let(:office) { create(:office) }

      it "returns nationals holidays" do
        expect(subject.from_office).to include(day: 7, month: 9)
      end
    end

    context "with nationals and regionals holidays" do
      let(:office) { create(:office, :with_holiday) }

      it "returns nationals holidays" do
        day = office.regional_holidays.first.day
        month = office.regional_holidays.first.month
        expect(subject.from_office).to include({ day: 7, month: 9 }, { day: day, month: month })
      end
    end

    context "without any holiday" do
      let(:office) { create(:office) }

      before do
        from = 1.year.ago.to_date
        to = DateTime.current
        allow(Holidays).to receive(:between).with(from, to, :br, :informal).and_return([])
      end

      it { expect(subject.from_office).to be_empty }
    end
  end

  describe "#nationals" do
    subject { described_class.new }

    context "without holidays" do
      before do
        from = 1.year.ago.to_date
        to = DateTime.current
        allow(Holidays).to receive(:between).with(from, to, :br, :informal).and_return([])
      end

      it { expect(subject.nationals).to be_empty }
    end

    context "with holidays" do
      it "returns holidays" do
        expect(subject.nationals).to include(month: 9, day: 7)
      end
    end
  end
end
