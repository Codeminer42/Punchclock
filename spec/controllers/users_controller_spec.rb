require 'spec_helper'

describe UsersController do
  let(:user) { create(:user) }
  before { login user }

  describe 'PUT update' do
    context 'with valid informations' do
      let(:user_attributes)  { { name: '1234', email: '1234@1234.com', hour_cost: 15.0 } }

      before { put(:update, id: user.id, user: user_attributes) }

      it 'should update user' do
        expect(assigns(:user)).to have_attributes(user_attributes)
      end
    end
  end

  describe 'GET index' do
    before do
      get :index
    end

    it "returns a success response status" do
      expect(response.status).to eq(200)
    end
  end
end
