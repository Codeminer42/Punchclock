require 'spec_helper'

describe UsersController do
  let(:user) { create(:user) }
  before { login user }

  describe 'PUT update' do
    context 'with valid information' do
      let(:user_attributes) { { name: '1234', email: '1234@1234.com', hour_cost: 15.0 } }

      it 'should update user' do
        put :update, params: { id: user.id, user: user_attributes }
        expect(controller.current_user).to have_attributes(user_attributes)
      end

      it 'redirects to root_path' do
        put :update, params: { id: user.id, user: user_attributes }
        expect(response).to redirect_to root_path
      end
    end

    context 'with invalid information' do
      let(:user_attributes) { { name: '1234', email: '1234@' } }

      it 'renders "edit" template ' do
        put :update, params: { id: user.id, user: user_attributes }
        expect(response).to render_template 'edit'
      end
    end
  end
end
