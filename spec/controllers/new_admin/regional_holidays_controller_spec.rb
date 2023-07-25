# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewAdmin::RegionalHolidaysController do
  describe 'GET #index' do
    let!(:new_york)    { create(:city, name: 'New York') }
    let!(:los_angeles) { create(:city, name: 'Los Angeles') }
    let!(:miami)       { create(:city, name: 'Miami') }
    let!(:chicago)     { create(:city, name: 'Chicago') }
    let!(:fresno)      { create(:city, name: 'San Diego') }

    let!(:new_york_holiday) do
      create(:regional_holiday, cities: [new_york], day: 4, month: 7, name: 'Independence Day')
    end
    let!(:la_holiday) do
      create(:regional_holiday, cities: [los_angeles], day: 1, month: 1, name: 'New Year')
    end
    let!(:miami_holiday) do
      create(:regional_holiday, cities: [miami], day: 25, month: 12, name: 'Christmas')
    end
    let!(:chicago_holiday) do
      create(:regional_holiday, cities: [chicago], month: 11, name: 'Thanksgiving Day')
    end

    it do
      is_expected.to permit(:regional_holiday_id, :month, { city_ids: [] }).for(:index, verb: :get)
    end

    it 'renders the index template' do
      get :index

      expect(response).to render_template(:index)
    end

    it 'assigns all cities with holidays to @cities_with_holidays' do
      get :index

      expect(assigns(:cities_with_holidays)).to contain_exactly(new_york, los_angeles, miami, chicago)
    end

    context 'when no filter options are provided' do
      it 'assigns all regional holidays correctly' do
        get :index

        expect(assigns(:regional_holidays)).to contain_exactly(new_york_holiday, la_holiday, miami_holiday, chicago_holiday)
      end
    end

    context 'when using regional_holiday_id option' do
      it 'returns the specified regional holiday' do
        get :index, params: { regional_holiday_id: new_york_holiday.id }

        expect(assigns(:regional_holidays)).to contain_exactly(new_york_holiday)
      end

      it 'returns empty list when the provided regional holiday id does not exist' do
        get :index, params: { regional_holiday_id: -1 }

        expect(assigns(:regional_holidays)).to be_empty
      end
    end

    context 'when using city_ids option' do
      it 'returns regional holidays from the specified cities' do
        get :index, params: { city_ids: [miami.id, los_angeles.id] }

        expect(assigns(:regional_holidays)).to contain_exactly(miami_holiday, la_holiday)
      end

      it 'returns empty list when the provided cities do not have any regional holiday' do
        get :index, params: { city_ids: [fresno.id] }

        expect(assigns(:regional_holidays)).to be_empty
      end
    end

    context 'when using month option' do
      it 'returns all regional holidays from the specified month' do
        get :index, params: { month: 12 }

        expect(assigns(:regional_holidays)).to contain_exactly(miami_holiday)
      end

      it 'returns empty list when the month does not have any regional holiday' do
        get :index, params: { month: 13 }

        expect(assigns(:regional_holidays)).to be_empty
      end
    end

    context 'when using multiple options' do
      it 'returns regional holidays matching all options' do
        get :index, params: { city_ids: [new_york.id], month: 7 }

        expect(assigns(:regional_holidays)).to contain_exactly(new_york_holiday)
      end

      it 'returns empty list when no regional holidays match all filter options' do
        get :index, params: { city_ids: [los_angeles.id], month: 7 }

        expect(assigns(:regional_holidays)).to be_empty
      end
    end

    context 'when using invalid option values' do
      it 'returns empty list for invalid regional_holiday_id' do
        get :index, params: { regional_holiday_id: 'invalid_id' }

        expect(assigns(:regional_holidays)).to be_empty
      end

      it 'returns empty list for invalid month' do
        get :index, params: { month: 'invalid_month' }

        expect(assigns(:regional_holidays)).to be_empty
      end

      it 'returns empty list for invalid city_ids' do
        get :index, params: { city_ids: ['invalid_city_id'] }

        expect(assigns(:regional_holidays)).to be_empty
      end
    end
  end
end