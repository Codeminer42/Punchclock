# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewAdmin::RegionalHolidaysController do

  describe 'GET #index' do
    let(:user) { create(:user, :admin) }
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

    before { sign_in user }

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

    describe 'pagination' do
      it 'paginates results' do
        get :index, params: { per: 2 }

        expect(assigns(:regional_holidays).count).to eq(2)
      end

      it 'decorates regional holidays' do
        get :index, params: { per: 1 }

        expect(assigns(:regional_holidays).last).to be_an_instance_of(RegionalHolidayDecorator)
      end
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user, :admin) }
    let(:city) { create(:city) }

    let!(:regional_holiday) do
      create(:regional_holiday, cities: [city])
    end

    before do
      sign_in user
      get :show, params: { id: regional_holiday.id }
    end

    it { is_expected.to respond_with(:ok) }

    it 'renders show template' do
      expect(response).to render_template(:show)
    end

    it 'assigns holiday to @regional_holiday' do
      expect(assigns(:regional_holiday)).to eq(regional_holiday)
    end
  end

  describe 'GET #new' do
    let(:user) { create(:user, :admin) }

    before do
      sign_in user
      get :new
    end

    it { is_expected.to respond_with(:ok) }

    it 'renders new template' do
      expect(response).to render_template(:new)
    end

    it 'assigns a new holiday to @regional_holiday' do
      expect(assigns(:regional_holiday)).to be_an_instance_of(RegionalHoliday)
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user, :admin) }
    let!(:city) { create(:city) }

    before { sign_in user }

    context 'when all parameters are correct' do
      describe 'http response' do
        before do
          post :create, params: { regional_holiday: { name: 'foobar holiday', day: 1, month: 12, city_ids: city.id } }
        end

        it { is_expected.to redirect_to new_admin_regional_holidays_path }
        it { is_expected.to set_flash[:notice] }
      end

      it "creates a new regional holiday" do
        expect do
          post :create, params: { regional_holiday: { name: 'foobar holiday', day: 1, month: 12, city_ids: city.id } }
        end.to change(RegionalHoliday, :count).from(0).to(1)
      end
    end

    context 'when record is not properly saved' do
      describe 'http response' do
        before do
          post :create, params: { regional_holiday: { name: nil, day: 1, month: 12, city_ids: city.id } }
        end

        it { is_expected.to render_template(:new) }
        it { is_expected.to respond_with(:unprocessable_entity) }
        it { is_expected.to set_flash.now[:alert] }
      end
    end
  end

  describe 'GET #edit' do
    let(:user) { create(:user, :admin) }
    let(:city) { create(:city) }

    let!(:regional_holiday) do
      sign_in user
      create(:regional_holiday, cities: [city])
    end

    before do
      get :edit, params: { id: regional_holiday.id }
    end

    it { is_expected.to respond_with(:ok) }

    it 'renders edit template' do
      expect(response).to render_template(:edit)
    end

    it 'assigns a new holiday to @regional_holiday' do
      expect(assigns(:regional_holiday)).to eq(regional_holiday)
    end
  end

  describe 'PATCH #update' do
    let(:user) { create(:user, :admin) }
    let(:city) { create(:city) }

    let!(:regional_holiday) do
      create(:regional_holiday, cities: [city])
    end

    before { sign_in user }

    context 'when parameters are correct' do
      describe 'http response' do
        before do
          patch :update, params: { id: regional_holiday.id,
                                   regional_holiday: { name: 'edited holiday', day: 1, month: 12, city_ids: city.id } }
        end

        it { is_expected.to redirect_to new_admin_show_regional_holiday_path(id: regional_holiday.id) }
        it { is_expected.to set_flash[:notice] }
      end

      it "updates regional holiday" do
        expect do
          patch :update, params: { id: regional_holiday.id,
                                   regional_holiday: { name: 'edited holiday', day: 1, month: 12, city_ids: city.id } }
        end.to change { regional_holiday.reload.name }.to('edited holiday')
      end
    end

    context 'when record is not properly updated' do
      before do
        patch :update, params: { id: regional_holiday.id,
                                 regional_holiday: { name: nil, day: 1, month: 12, city_ids: city.id } }
      end

      it { is_expected.to render_template(:edit) }
      it { is_expected.to respond_with(:unprocessable_entity) }
      it { is_expected.to set_flash.now[:alert] }
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user, :admin) }
    let!(:regional_holiday) { create(:regional_holiday) }

    before { sign_in user }

    context 'when record is successfully deleted' do
      describe 'http response' do
        before do
          delete :destroy, params: { id: regional_holiday.id }
        end

        it { is_expected.to redirect_to new_admin_regional_holidays_path }
        it { is_expected.to set_flash[:notice] }
      end

      it "destroys regional holiday" do
        expect do
          delete :destroy, params: { id: regional_holiday.id }
        end.to change(RegionalHoliday, :count).from(1).to(0)
      end
    end

    context 'when record is not properly deleted' do
      before do
        allow_any_instance_of(RegionalHoliday).to receive(:destroy).and_return(false)
        allow_any_instance_of(RegionalHoliday).to receive_message_chain(:errors, :full_messages).and_return(['Foobar'])

        delete :destroy, params: { id: regional_holiday.id }
      end

      it { is_expected.to render_template(:index) }
      it { is_expected.to respond_with(:unprocessable_entity) }
      it { is_expected.to set_flash.now[:alert].to('Foobar') }
    end
  end
end
