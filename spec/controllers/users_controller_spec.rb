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
    it "returns a success response status" do
      get :index
      expect(response).to be_ok
    end

    it "assigns @users" do
      get :index
      expect(assigns(:users)).to eq([user])
    end

    it "renders the users template" do
      get :index
      expect(response).to render_template("users/index")
    end
  end
end
