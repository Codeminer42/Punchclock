# frozen_string_literal: true

RSpec.describe RegionalHolidayDecorator do
  describe '#cities' do
    subject { regional_holiday.cities }

    context 'when there are no cities' do
      let(:regional_holiday) { build_stubbed(:regional_holiday, cities: []).decorate }

      it 'does not raise any error' do
        expect { subject }.not_to raise_error
      end

      it 'returns an empty string' do
        expect(subject).to eq ''
      end
    end

    context 'when there is only one city' do
      let(:regional_holiday) { build_stubbed(:regional_holiday, cities: [City.new(name: 'Aracaju')]).decorate }

      it 'returns the city name correctly' do
        expect(subject).to eq 'Aracaju'
      end
    end

    context 'when there are multiple cities' do
      let(:regional_holiday) { build_stubbed(:regional_holiday, cities: cities).decorate }
      let(:cities)           { [City.new(name: 'Guará'), City.new(name: 'Natal'), City.new(name: 'Pinhão')] }

      it 'returns the cities names separated by comma' do
        expect(subject).to eq 'Guará, Natal, Pinhão'
      end
    end
  end
end
