require 'rails_helper'

RSpec.describe City, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:state) }
    it { is_expected.to have_and_belong_to_many(:regional_holidays) }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe '#holidays' do
    let!(:city) { create(:city) }

    context 'when there are no holidays' do
      it 'returns an empty array' do
        expect(city.holidays).to be_empty
      end
    end

    context 'when there are city holidays' do
      let(:regional_holiday) { create(:regional_holiday) }

      it 'returns city holidays' do
        city.regional_holidays.push(regional_holiday)
        city_holidays = [{ day: regional_holiday.day, month: regional_holiday.month }]

        expect(city.holidays).to eq(city_holidays)
      end
    end
  end

  describe '#with_holidays' do
    let!(:city_without_holiday) { create(:city) }
    let(:city_with_holiday) { create(:city, regional_holidays: [regional_holiday]) }
    let(:regional_holiday) { create(:regional_holiday) }

    it 'returns only cities with holidays' do
      expect(City.with_holidays).to eq([city_with_holiday])
    end
  end
end
