require 'spec_helper'
require  "#{Rails.root}/spec/support/controller_helpers.rb"

describe Api::V1::TokenController, :type => :controller do
  let(:user) { create(:user) }
  describe 'POST api/v1/request' do
    subject { post :request_token, params: params  }
    
    context 'when credentials are correct' do
      let(:params) { { email: user.email, password: user.password } }

      it { is_expected.to have_http_status(:created) }

      it 'returns a valid access token' do
        body = JSON.parse(subject.body)
        expect(body).to include('access_token')
        expect(body.access_token).to include('access_token')
      end
    end

    context 'when credentials are incorrect' do
      let(:params) { { email: user.email, password: 'incorrect_password' } }

      it { is_expected.to have_http_status(:unprocessable_entity) }

      it 'returns a access token' do
        expect(JSON.parse(subject.body)).to eq({ 'error' => 'Usuário ou Senha incorretos' })
      end
    end
  end
  describe 'POST api/v1/refresh' do
    subject { post :refresh_token }

    context 'when Authentication header is valid' do
      before do
        api_auth(user.id)
      end

      it { is_expected.to have_http_status(:created) }

      it 'returns a new access token' do
        expect(JSON.parse(subject.body)).to include('access_token')
      end

      it 'invalidates old access token' do
        old_token = request.headers['Authentication'].slice('Bearer ')
        subject
        expect{Jwt::Verify.call(old_token)}.to raise_error(Jwt::Verify::InvalidError)
      end
    end

    context 'when Authentication header is invalid' do
      before do
        request.headers.merge!({ Authorization: 'invalid_token'})
      end

      it { is_expected.to have_http_status(:unauthorized) }

      it 'invalidates old access token' do
        expect(JSON.parse(subject.body)).to eq({ 'error' => 'unauthorized' })
      end
    end
  end
end
