# frozen_string_literal: true

require 'rails_helper'

describe NewAdmin::AllocationsController do
  render_views

  let(:user) { create(:user, name: "Jorge").decorate }
  let!(:allocation) { create(:allocation,
                              start_at: 2.months.after,
                              end_at: 3.months.after,
                              user: user,
                              ongoing: true).decorate }

  let(:allocation_forecast) { RevenueForecastService.allocation_forecast(allocation) }
  let(:page) { Capybara::Node::Simple.new(response.body) }

  before do
    allow(controller).to receive(:authenticate_user!)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #show' do
    it 'returns successful status' do
      get :show, params: { id: allocation.id }

      expect(response).to have_http_status(:ok)
    end

    it 'returns the allocation' do
      get :show, params: { id: allocation.id }

      expect(page).to have_content(allocation.project_name)
                  .and have_content(user.name)
                  .and have_content(I18n.l(allocation.start_at))
                  .and have_content(I18n.l(allocation.end_at))
                  .and have_content(allocation.hourly_rate)
                  .and have_content(allocation.ongoing)
                  .and have_content(allocation.days_left)
    end

    it 'returns the allocation forecast' do
      get :show, params: { id: allocation.id }

      expect(page).to have_content(I18n.l(allocation.end_at, format: :short))
                  .and have_content(allocation_forecast.first[:working_hours])
    end
  end
end
