require 'spec_helper'

describe PasswordsController do
  before { login user }

  describe 'PATCH update' do
    let(:current_password) { 'password' }
    let(:new_password) { '12345678' }

    let(:user) { create :user, password: current_password }

    describe 'when user update your account' do
      context 'with correct authorization' do
        context 'with valid password' do
          it 'update your password' do
            params = {
              id: user.id,
              user: {
                current_password: current_password,
                password: new_password,
                password_confirmation: new_password
              }
            }

            patch :update, params
            expect(response).to redirect_to edit_user_path(user)
          end
        end

        context 'with invalid password' do
          it 'update your password' do
            params = {
              id: user.id,
              user: {
                current_password: current_password,
                password: '',
                password_confirmation: new_password
              }
            }

            patch :update, params
            expect(response).to render_template(:edit)
          end
        end
      end
    end
  end
end
