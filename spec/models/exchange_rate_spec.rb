require 'rails_helper'

RSpec.describe ExchangeRate, type: :model do
  let(:exchange_rate) { create :exchange_rate }

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
end
