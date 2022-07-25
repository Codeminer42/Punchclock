require 'spec_helper'
require  "#{Rails.root}/spec/support/controller_helpers.rb"

describe Api::V1::TokenController, type: :controller do
  let(:user) { create(:user) }
  describe 'POST api/v1/request' do
    subject { post :request_token, params: params }

    context 'when credentials are correct' do
      let(:params) { { email: user.email, password: user.password } }
      let(:body) { JSON.parse(subject.body) }

      it { is_expected.to have_http_status(:created) }

      it 'returns a access token' do
        subject
        expect(body).to include('access_token')
      end

      it 'returned access token is valid' do
        subject
        generated_jwt = body['access_token']
        expect { Jwt::Verify.call(generated_jwt) }.not_to raise_error(Jwt::Verify::InvalidError)
      end
    end

    context 'when credentials are incorrect' do
      let(:params) { { email: user.email, password: 'incorrect_password' } }

      it { is_expected.to have_http_status(:unprocessable_entity) }

      it 'returns a access token' do
        expect(JSON.parse(subject.body)).to eq({ 'error' => I18n.t('errors.messages.wrong_credentials') })
      end
    end
  end

  describe 'POST api/v1/refresh' do
    subject { post :refresh_token }
    let(:body) { JSON.parse(subject.body) }

    context 'when Authorization header is valid' do
      before do
        use_auth_header_for(user.id)
      end

      it { is_expected.to have_http_status(:created) }

      it 'returns a new access token' do
        expect(body).to include('access_token')
      end

      it 'returned access token is valid' do
        subject
        generated_jwt = body['access_token']
        expect { Jwt::Verify.call(generated_jwt) }.not_to raise_error(Jwt::Verify::InvalidError)
      end

      it 'invalidates old access token' do
        old_token = current_jwt
        subject
        expect { Jwt::Verify.call(old_token) }.to raise_error(Jwt::Verify::InvalidError)
      end
    end

    context 'when Authentication header is invalid' do
      before do
        request.headers.merge!({ Authorization: 'invalid_token' })
      end

      it { is_expected.to have_http_status(:unauthorized) }

      it 'invalidates old access token' do
        expect(body).to eq({ 'error' => 'unauthorized' })
      end
    end
  end
end
