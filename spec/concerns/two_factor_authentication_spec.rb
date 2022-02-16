require 'spec_helper'

RSpec.describe TwoFactorAuthentication, type: :controller do
  let(:user) { create(:user, otp_secret: 'secret', otp_required_for_login: is_otp_required) }
  let(:user_params) { { email: user.email, password: 'password' } }
  let(:otp_user_params) { user_params.merge(otp_attempt: user.current_otp) }

  controller ApplicationController do
    include TwoFactorAuthentication
    before_action :authenticate_otp
    def action; end
  end

  before do
    routes.draw { post :action, to: 'anonymous#action' }
  end

  describe 'when two factor is disabled' do
    let(:is_otp_required) { false }

    before { post :action, params: { user: user_params } }

    it 'returns nothing' do
      expect(response.body).to eq ''
    end
  end

  describe 'when two factor is enabled' do
    let(:is_otp_required) { true }

    describe 'when OTP code is not provided' do
      before { post :action, params: { user: user_params } }

      it 'redirects to the two factor page' do
        expect(session[:otp_user_id]).to eq user.id
        expect(response.body).to render_template 'devise/sessions/two_factor'
      end
    end

    describe 'when OTP code is provided' do
      before { post :action, params: { user: otp_user_params } }

      it 'clear session data and return nothing' do
        expect(session[:otp_user_id]).to be_nil
        expect(response.body).to eq ''
      end
    end
  end
end
