require 'rails_helper'

RSpec.describe ExchangeRate, type: :model do
  it { should enumerize(:currency).in(%w[USD]) }

  describe 'validations' do
    it { is_expected.to validate_presence_of :currency }
    it { is_expected.to validate_presence_of :month }
    it { is_expected.to validate_presence_of :year }
    it { is_expected.to validate_presence_of :rate }

    it { is_expected.to validate_numericality_of(:month).only_integer }
    it { is_expected.to validate_numericality_of(:year).only_integer }

    it { is_expected.to validate_numericality_of(:month).is_greater_than_or_equal_to(1) }
    it { is_expected.to validate_numericality_of(:month).is_less_than_or_equal_to(12) }

    it { is_expected.to validate_numericality_of(:year).is_greater_than(2010) }

    it { is_expected.to validate_numericality_of(:rate).is_greater_than_or_equal_to(1) }
  end

  describe ".for_month_and_year!" do
    let(:result) { described_class.for_month_and_year!(month, year) }

    before do
      travel_to(Date.new(2020, 6, 15))

      create(:exchange_rate, month: 2, year: 2015)
      create(:exchange_rate, month: 9, year: 2016)
      create(:exchange_rate, month: 6, year: 2019)
      create(:exchange_rate, month: 7, year: 2020)
    end

    after { travel_back }

    context "when current month is equals to the requested month/year" do
      let(:month) { 6 }
      let(:year)  { 2020 }

      it "returns last month rate" do
        exchange_rate = create(:exchange_rate, month: 5, year: 2020)

        expect(result).to eq(exchange_rate)
      end
    end

    context "when current month is minor than the requested month/year" do
      let(:month) { 11 }
      let(:year)  { 2022 }

      it "returns last month rate" do
        exchange_rate = create(:exchange_rate, month: 5, year: 2020)

        expect(result).to eq(exchange_rate)
      end
    end

    context "when the requested month/year is minor than current month" do
      let(:month) { 5 }
      let(:year)  { 2019 }

      it "returns the exchange rate of the month before the requested one" do
        exchange_rate = create(:exchange_rate, month: 4, year: 2019)

        expect(result).to eq(exchange_rate)
      end
    end
  end
end
