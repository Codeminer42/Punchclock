# frozen_string_literal: true

require 'rails_helper'

describe NewAdmin::AllocationsController do
  describe 'GET #show' do
    let(:user) { create(:user) }
    let!(:allocation) { create(:allocation,
                                start_at: 2.months.after,
                                end_at: 3.months.after,
                                user: user,
                                ongoing: true) }


    it 'returns successful status' do
      get :show, params: { id: allocation.id }

      expect(response).to have_http_status(:ok)
    end

    it 'returns the allocation' do
      get :show, params: { id: allocation.id }

      expect(subject.instance_variable_get(:@allocation)).to eq(allocation)
    end

    it 'returns the allocation forecast' do
      get :show, params: { id: allocation.id }

      forecast = subject.instance_variable_get(:@allocation_forecast)

      month = allocation.start_at.month
      year = allocation.start_at.year

      expect(forecast.first[:month]).to eq(month)
      expect(forecast.first[:year]).to eq(year)
    end
  end
end
