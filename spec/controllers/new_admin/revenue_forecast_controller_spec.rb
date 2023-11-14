# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewAdmin::RevenueForecastController, type: :controller do
  include ActiveSupport::Testing::TimeHelpers

  let(:user) { create(:user, :admin) }

  before do
    travel_to Date.parse('2023-01-08')
    sign_in(user)
  end

  after { travel_back }

  context 'when allocations are present' do
    let(:developer) { create(:user).decorate }

    before do
      create(:allocation,
             start_at: 2.months.after,
             end_at: 3.months.after,
             user: developer,
             ongoing: true).decorate

      get :index
    end

    xit { is_expected.to respond_with(:ok) }

    xit 'renders index template' do
      expect(response).to render_template(:index)
    end

    xit 'assigns years range from presenter to @years_range' do
      expect(assigns(:years_range)).to eq(RevenueForecastPresenter::REVENUE_FORECAST_START_YEAR..2023)
    end
  end

  context 'when no allocations are present' do
    before { get :index }

    xit 'assigns default revenue forecast start year range to @years_range' do
      expect(
        assigns(:years_range)
      ).to eq(RevenueForecastPresenter::REVENUE_FORECAST_START_YEAR..RevenueForecastPresenter::REVENUE_FORECAST_START_YEAR)
    end
  end
end
