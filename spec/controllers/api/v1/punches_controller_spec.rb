require 'spec_helper'
require  "#{Rails.root}/spec/support/controller_helpers.rb"

describe Api::V1::PunchesController, :type => :controller do
  let(:user) { create(:user, :with_token) }
  subject { get :index }

  describe 'GET api/v1/punches' do
    before { create(:punch, user_id: user.id) }

    context 'when user is logged in' do
      let(:headers) { { token: user.token } }

      before { request.headers.merge(headers) }

      include_examples 'an authenticated resource action'

      it 'returns all punches for the current user' do
        expect(JSON.parse(subject.body)).to all(include('created_at', 'delta_as_hour', 'extra_hour', 'from', 'project', 'to'))
      end
    end

    context 'when user is not logged in' do
      include_examples 'an unauthenticated resource action'
    end
  end
end
