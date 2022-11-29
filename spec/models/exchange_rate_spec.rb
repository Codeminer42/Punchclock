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

    it { is_expected.to validate_numericality_of(:year).is_greater_than(2020) }

    it { is_expected.to validate_numericality_of(:rate).is_greater_than_or_equal_to(1) }
  end

  describe ".newest_by_month_and_year" do
    it "returns the newest exchange rate based on the month and year provided" do
      create(:exchange_rate, month: 1, year: 2022)
      create(:exchange_rate, month: 10, year: 2022)

      rate = create(:exchange_rate, month: 9, year: 2022)
      expect(described_class.newest_by_month_and_year(10, 2022)).to eq(rate)

      rate = create(:exchange_rate, month: 12, year: 2022)
      expect(described_class.newest_by_month_and_year(9, 2023)).to eq(rate)
    end
  end
end
