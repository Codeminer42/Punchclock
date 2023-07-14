# frozen_string_literal: true

require 'rails_helper'

describe NewAdmin::PunchesController do
  render_views

  let(:page) { Capybara::Node::Simple.new(response.body) }
  let(:punch) { FactoryBot.create(:punch).decorate }

  before do
    allow(controller).to receive(:authenticate_user!)
    allow(controller).to receive(:current_user).and_return(punch.user)
  end

  describe 'GET #show' do
    it 'returns successful status' do
      get :show, params: { id: punch.id }

      expect(response).to have_http_status(:ok)
    end

    it 'returns the punch' do
      get :show, params: { id: punch.id }

      expect(page).to have_content(punch.user_name)
                  .and have_content(punch.project_name)
                  .and have_content(punch.date)
                  .and have_content(punch.from)
                  .and have_content(punch.to)
                  .and have_content(punch.delta)
    end
  end
end
