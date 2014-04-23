require 'spec_helper'

describe UsersController do
  before { login user }

  describe 'PUT update' do
    let(:user) { create(:user) }

    context 'when user is admin' do
      let(:user) { create :user, is_admin: true }

      context 'with valid informations' do
        it 'should update user' do
          params = {
            id: user.id,
            user: { name: '1234', email: '1234@1234.com', hour_cost: '20.0' }
          }

          put :update, params
          expect(assigns(:user).name).to be == '1234'
          expect(assigns(:user).email).to be == '1234@1234.com'
          expect(assigns(:user).hour_cost).to be == 20.0
        end
      end
    end
  end
end
