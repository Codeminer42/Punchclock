require 'rails_helper'

RSpec.describe Api::V1::ApiController, type: :controller do
  let!(:company) { create(:company) }
  let!(:offices) { create_list(:office, 3, company: company) }
  let!(:user) { create(:user, :with_token, company: company, office: offices.first) }
  let(:token) { user.token }
  let(:app) { create(:oauth2_app) }
  let(:oauth2_token) { create(:oauth2_access_token, application_id: app.id, resource_owner_id: user.id) }
  let(:oauth2_token_expired) do
    create(:oauth2_access_token, :expired, application_id: app.id, resource_owner_id: user.id)
  end
  let(:token_header) { { token: token } }
  let(:oauth2_token_header) do
    { authorization: "Bearer #{oauth2_token.nil? ? oauth2_token_expired.plaintext_token : oauth2_token.plaintext_token}" }
  end

  controller do
    def index
      render plain: current_user.email
    end
  end

  context 'with valid token present' do
    it 'returns success' do
      request.headers.merge!(token_header)
      get :index
      expect(response).to be_successful
      expect(response.body).to eq(user.email)
    end

    context 'and invalid oauth2 token present' do
      let(:oauth2_token) { nil }
      it 'return success' do
        request.headers.merge!(token_header)
        request.headers.merge!(oauth2_token_header)

        get :index
        expect(response).to be_successful
        expect(response.body).to eq(user.email)
      end
    end
  end

  context 'with valid oauth2 token' do
    it 'returns success' do
      request.headers.merge!(oauth2_token_header)
      get :index
      expect(response).to be_successful
      expect(response.body).to eq(user.email)
    end

    context 'and invalid token present' do
      let(:token) { 'invalid token' }
      it 'returns success' do
        request.headers.merge!(token_header)
        request.headers.merge!(oauth2_token_header)

        get :index
        expect(response).to be_successful
        expect(response.body).to eq(user.email)
      end
    end
  end

  context 'with invalid token present' do
    let(:token) { 'invalid token' }

    it 'returns invalid token error' do
      request.headers.merge!(token_header)

      get :index
      expect(JSON.parse(response.body)).to eq('message' => 'Invalid Token')
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'with invalid oauth2 token present' do
    let(:oauth2_token) { nil }
    it 'returns invalid token error' do
      request.headers.merge!(oauth2_token_header)

      get :index
      expect(JSON.parse(response.body)).to eq('message' => 'Invalid Token')
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'with none token present' do
    it 'returns missing token error' do
      get :index
      expect(JSON.parse(response.body)).to eq('message' => 'Missing Token')
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'with user disabled' do
    it 'retuns invalid token error' do
      user.disable!
      request.headers.merge!(oauth2_token_header)
      get :index

      expect(JSON.parse(response.body)).to eq('message' => 'Invalid Token')
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
