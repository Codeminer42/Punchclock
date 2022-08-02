require 'spec_helper'

describe Api::V1::TokenController, type: :controller do
  let(:user) { create(:user) }
  let(:body) { JSON.parse(response.body) }
  
  describe 'POST api/v1/request' do
    context 'when credentials are correct' do
      let(:params) { { email: user.email, password: user.password } }

      it 'returns created status' do
        post :request_token, params: params
        expect(response).to have_http_status(:created)
      end

      it 'returns a access token' do
        post :request_token, params: params
        expect(body).to include('access_token')
      end

      it 'returns a access token' do
        post :request_token, params: params
        expect(body).to include('access_token')
      end

      it 'returned access token is valid' do
        post :request_token, params: params
        generated_jwt = body['access_token']
        expect { Jwt::Verify.call(generated_jwt) }.not_to raise_error
      end
    end

    context 'when credentials are incorrect' do
      let(:params) { { email: user.email, password: 'incorrect_password' } }
      
      it 'returns unprocessable entity status' do
        post :request_token, params: params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a access token' do
        post :request_token, params: params
        expect(body).to eq({ 'error' => I18n.t('errors.messages.wrong_credentials') })
      end
    end
  end

  describe 'POST api/v1/refresh' do
    context 'when Authorization header is valid' do
      before do
        use_auth_header_for(user.id)
      end

      it 'returns created status' do
        post :refresh_token
        expect(response).to have_http_status(:created)
      end

      it 'returns a new access token' do
        post :refresh_token
        expect(body).to include('access_token')
      end

      it 'returned access token is valid' do
        post :refresh_token
        generated_jwt = body['access_token']
        expect { Jwt::Verify.call(generated_jwt) }.not_to raise_error
      end

      it 'invalidates old access token' do
        old_token = current_jwt
        post :refresh_token
        expect { Jwt::Verify.call(old_token) }.to raise_error(Jwt::Verify::InvalidError)
      end
    end

    context 'when Authentication header is invalid' do
      before do
        request.headers.merge!({ Authorization: 'invalid_token' })
      end

      it 'returns unauthorized status' do
        post :refresh_token
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error message in body' do
        post :refresh_token
        expect(body).to eq({ 'error' => 'unauthorized' })
      end
    end

    context 'when Authentication header is a unsigned token' do
      before do
        payload = { exp: 1.week.from_now.to_i,
                    sub: user.id,
                    env: Rails.env,
                    jti: SecureRandom.uuid }

        unsigned_token = JWT.encode payload, nil, 'none'
        request.headers.merge!({ Authorization: unsigned_token })
      end

      it 'returns unauthorized status' do
        post :refresh_token
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error message in body' do
        post :refresh_token
        expect(body).to eq({ 'error' => 'unauthorized' })
      end
    end
  end
end
