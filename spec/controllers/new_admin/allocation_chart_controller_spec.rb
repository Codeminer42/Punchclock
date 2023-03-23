# frozen_string_literal: true

require 'rails_helper'

describe NewAdmin::AllocationChartController do
  let(:user) { create(:user) }

  before do
    allow(controller).to receive(:authenticate_user!)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    context 'when there are no allocations' do
      it 'returns successful status' do
        get :index

        expect(response).to have_http_status(:ok)
      end

      it 'returns users within an empty allocation' do
        get :index

        expect(subject.instance_variable_get(:@allocations)).to include(having_attributes(user_id: user.id))
      end
    end

    context 'when there are active allocations' do
      let!(:allocation) { create(:allocation,
                                  start_at: 2.months.after,
                                  end_at: 3.months.after,
                                  user: user,
                                  ongoing: true) }


      it 'returns successful status' do
        get :index

        expect(response).to have_http_status(:ok)
      end

      it 'returns allocations' do
        get :index

        expect(subject.instance_variable_get(:@allocations)).to include(allocation)
      end
    end
  end
end
