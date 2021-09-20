require 'rails_helper'

RSpec.describe ApplicationController, :type => :controller do
  controller do
    def index
      render json: { success: true }
    end
  end

  describe 'when logged in' do
    let(:user) { create(:user) }

    before { sign_in user }

    it 'current user returns a user Decorator' do
      get :index
      expect(controller.current_user).to be_an_instance_of(UserDecorator)
      expect(controller.current_user).to eq(user)
    end
  end
end
