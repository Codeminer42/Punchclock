require 'spec_helper'
require  "#{Rails.root}/spec/support/controller_helpers.rb"

describe Api::V1::PunchesController, :type => :controller do
  let(:user) { create(:user, :with_token) }

  describe 'GET api/v1/punches' do
    subject { get :index }
    before { create(:punch, user_id: user.id) }

    context 'when user is logged in' do
      let(:headers) { { token: user.token } }

      before { request.headers.merge(headers) }

      include_examples 'an authenticated resource action'

      it { is_expected.to have_http_status(:ok) }

      it 'returns all punches for the current user' do
        expect(JSON.parse(subject.body)).to all(include('created_at', 'delta_as_hour', 'extra_hour', 'from', 'project', 'to'))
      end
    end

    context 'when user is not logged in' do
      include_examples 'an unauthenticated resource action'
    end
  end

  describe 'GET api/v1/punches/:id' do
    subject { get :show, params: { id: punch.id } }
    let(:punch) { create(:punch, user_id: user.id) }

    context 'when user is logged in' do
      let(:headers) { { token: user.token } }

      before { request.headers.merge(headers) }

      include_examples 'an authenticated resource action'

      it { is_expected.to have_http_status(:found) }

      it 'returns selected punch for the current user' do
        expect(JSON.parse(subject.body)).to include('created_at', 'delta_as_hour', 'extra_hour', 'from', 'project', 'to')
      end
    end

    context 'when user is not logged in' do
      include_examples 'an unauthenticated resource action'
    end
  end
end
