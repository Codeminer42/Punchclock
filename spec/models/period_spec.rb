require 'spec_helper'

describe Period do
  describe '#contains_or_create' do
    let(:date) { Date.current }
    let(:company) { create :company }
    let(:period) { company.periods.contains_or_create date }

    context 'when has no current period' do
      let(:month_len) { 28 }
      before{ Period.delete_all }
      it 'creates one' do
        expect(period.range.to_a.length).to be > month_len
        expect(period.range).to include date
      end
    end

    context 'when has current period' do
      let!(:new_period) do
        create :period, range: 15.days.ago..15.days.from_now, company: company
      end
      it 'returns the period' do
        expect(period).to be == new_period
      end
    end
  end

  describe 'validations' do
    let(:company) { create :company }

    context 'when have 2 periods with overlap days' do
      let!(:period) do
        create :period, range: 15.days.ago..15.days.from_now, company: company
      end
      let!(:new_period) do
        build :period, range: 10.days.ago..20.days.from_now, company: company
      end

      it 'invalids the second' do
        expect(new_period).to_not be_valid
      end
    end
  end
end
