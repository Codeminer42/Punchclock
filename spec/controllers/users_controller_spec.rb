require 'spec_helper'

describe UsersController do
  before { login user }

  describe 'PUT update' do
    let(:user) { create(:user) }

    context 'when user is admin' do
      let(:user) { create :user, is_admin: true }

      context 'with valid informations' do
        let(:user_attributes)  { { name: '1234', email: '1234@1234.com', hour_cost: 20.0 } }

        before { put(:update, id: user.id, user: user_attributes) }

        it 'should update user' do
          expect(assigns(:user)).to have_attributes(user_attributes)
        end
      end
    end
  end
end
