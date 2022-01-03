require 'spec_helper'

describe Api::CompaniesController, :type => :controller do
  let!(:company) { create(:company) }
  let!(:offices) { create_list(:office, 3, company: company) }
  let!(:user) { create(:user, :with_token, company: company, office: offices.first) }
  let(:headers) { { token: user.token } }

  describe 'GET api/offices' do
    subject { get :offices }

    context 'when api token is valid' do
      before do
        request.headers.merge!(headers)
      end

      it { is_expected.to have_http_status(:ok) }

      it 'returns content type json' do
        expect(subject.content_type).to eq 'application/json; charset=utf-8'
      end

      it 'returns company offices' do
        expect(subject.body).to eq(offices.to_json)
      end
    end

    context 'when api token is missing' do
      it { is_expected.to have_http_status(:unauthorized) }

      it 'returns a missing token message' do
        expect(JSON.parse(subject.body)).to eq('message' => 'Missing Token')
      end
    end
  end

  describe 'GET api/users' do
    subject { get :users }

    context 'when api token is valid' do
      before do
        request.headers.merge!(headers)
      end

      it { is_expected.to have_http_status(:ok) }

      it 'returns content type json' do
        expect(subject.content_type).to eq 'application/json; charset=utf-8'
      end

      it 'returns company users' do
        expect(JSON.parse(subject.body)).to eq(
          [JSON.parse(user.to_json(only: %i[email name github office_id]))]
        )
      end
    end

    context 'when api token is missing' do
      it { is_expected.to have_http_status(:unauthorized) }

      it 'returns a missing token message' do
        expect(JSON.parse(subject.body)).to eq('message' => 'Missing Token')
      end
    end
  end
end
