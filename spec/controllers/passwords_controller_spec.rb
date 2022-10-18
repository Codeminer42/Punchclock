require 'spec_helper'

describe PasswordsController do
  before { login user }

  describe 'PATCH update' do
    let(:current_password) { 'password' }
    let(:new_password) { '12345678' }

    let(:user) { create :user, password: current_password }

    describe 'when user updates its account' do
      context 'with correct authorization' do
        context 'with valid password params' do
          it 'updates user password' do
            params = {
              id: user.id,
              user: {
                current_password: current_password,
                password: new_password,
                password_confirmation: new_password
              }
            }

            patch :update, params: params
            expect(response).to redirect_to edit_user_path
          end
        end

        context 'with the invalid param of' do
          context '"password"' do
            it 'renders edit' do
              params = {
                id: user.id,
                user: {
                  current_password: current_password,
                  password: '',
                  password_confirmation: new_password
                }
              }

              patch :update, params: params
              expect(response).to render_template(:edit)
            end

            it 'yields a "password cannot be empty" flash alert' do
              params = {
                id: user.id,
                user: {
                  current_password: current_password,
                  password: '',
                  password_confirmation: new_password
                }
              }

              patch :update, params: params
              expect(flash[:alert]).to have_content('Senha não pode ficar em branco')
            end
          end

          context '"current password"' do
            it 'renders edit' do
              params = {
                id: user.id,
                user: {
                  current_password: 'pasword',
                  password: new_password,
                  password_confirmation: new_password
                }
              }

              patch :update, params: params
              expect(response).to render_template(:edit)
            end

            it 'yields a "invalid current password" flash alert' do
              params = {
                id: user.id,
                user: {
                  current_password: 'pasword',
                  password: new_password,
                  password_confirmation: new_password
                }
              }

              patch :update, params: params
              expect(flash[:alert]).to have_content('Current password não é válido')
            end
          end

          context '"password confirmation"' do
            it 'renders edit' do
              params = {
                id: user.id,
                user: {
                  current_password: current_password,
                  password: new_password,
                  password_confirmation: ''
                }
              }

              patch :update, params: params
              expect(response).to render_template(:edit)
            end

            it 'yields a "password confirmation mismatch" flash alert' do
              params = {
                id: user.id,
                user: {
                  current_password: current_password,
                  password: new_password,
                  password_confirmation: ''
                }
              }

              patch :update, params: params
              expect(flash[:alert]).to have_content('Password confirmation não é igual a Password')
            end
          end
        end
      end
    end
  end
end
