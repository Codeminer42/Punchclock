# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegionalHolidaysQuery do
  shared_examples 'a query with no results' do
    it 'does not raise any error' do
      expect { call }.not_to raise_error
    end

    it 'returns an empty list' do
      result = call

      expect(result).to be_empty
    end
  end

  describe '#call' do
    subject(:call) { described_class.new(**options).call }

    let(:guarapuava) { create(:city, name: 'Guarapuava') }
    let(:pitanga)    { create(:city, name: 'Pitanga') }
    let(:teresina)   { create(:city, name: 'Teresina') }
    let(:imbituva)   { create(:city, name: 'Imbituva') }

    let!(:g_anniversary) do
      create(:regional_holiday, cities: [guarapuava], day: 9, month: 12, name: 'Aniversário de Guarapuava')
    end
    let!(:t_anniversary) do
      create(:regional_holiday, cities: [teresina], day: 16, month: 8, name: 'Aniversário de Teresina')
    end
    let!(:piter_holiday) do
      create(:regional_holiday, cities: [pitanga, teresina], month: 12)
    end
    let!(:g_patron_saint_day) do
      create(:regional_holiday, cities: [guarapuava], month: 2)
    end

    context 'with no option provided' do
      let(:options) { {} }

      it 'returns all the regional holidays' do
        result = call

        expect(result).to contain_exactly(g_anniversary, t_anniversary, piter_holiday, g_patron_saint_day)
      end
    end

    context 'with regional_holiday_id option' do
      let(:options) { { regional_holiday_id: g_anniversary.id } }

      it 'returns the specified regional holiday' do
        result = call

        expect(result).to contain_exactly(g_anniversary)
      end

      context 'when a regional holiday with the provided id does not exist' do
        let(:options) { { regional_holiday_id: -1 } }

        it_behaves_like 'a query with no results'
      end
    end

    context 'with city_ids option' do
      let(:options) { { city_ids: [pitanga.id, guarapuava.id] } }

      it 'returns regional holidays from the specified cities' do
        result = call

        expect(result).to contain_exactly(g_anniversary, piter_holiday, g_patron_saint_day)
      end

      context 'when the provided cities do not have any regional holiday' do
        let(:options) { { city_ids: [imbituva.id] } }

        it_behaves_like 'a query with no results'
      end
    end

    context 'with month option' do
      let(:options) { { month: 12 } }

      it 'returns all regional holidays from the specified month' do
        result = call

        expect(result).to contain_exactly(g_anniversary, piter_holiday)
      end

      context 'when the month does not have any regional holiday' do
        let(:options) { { month: 13 } }

        it_behaves_like 'a query with no results'
      end
    end

    context 'with multiple options' do
      let(:options) { { city_ids: [guarapuava.id], month: 2 } }

      it 'returns regional holidays matching all options' do
        result = call

        expect(result).to contain_exactly(g_patron_saint_day)
      end
    end

    context 'with an invalid option value' do
      let(:options) { { regional_holiday_id: 'safas', month: 'feb', city_ids: ['l'] } }

      it_behaves_like 'a query with no results'
    end
  end
end
