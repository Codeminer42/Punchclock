require 'spec_helper'
require  "#{Rails.root}/spec/support/controller_helpers.rb"

describe Api::V1::PunchesController, :type => :controller do
  let(:user) { create(:user, :with_token) }
  let(:project) { create(:project, company: user.company) }
  let(:headers) { { token: user.token } }

  describe 'GET api/v1/punches' do
    subject { get :index }

    before { create(:punch, user_id: user.id) }

    context 'when user is logged in' do
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

  describe 'POST api/v1/punches' do
    context 'when api token is valid and params are valid' do
      let(:params) {
        {
          "punches": [
            {
              "from": "2022-04-19T12:00:00.000Z",
              "to": "2022-04-19T15:00:00.000Z",
              "project_id": project.id
            },
            {
              "from": "2022-04-19T16:00:00.000Z",
              "to": "2022-04-19T21:00:00.000Z",
              "project_id": project.id
            }
          ]
        }
      }

      subject { post :create, params: params }
      before { request.headers.merge(headers) }

      include_examples 'an authenticated create resource action'

      it 'returns created punches' do
        created_punches = JSON.parse(subject.body).map do |punch|
          {
            from: punch['from'],
            to: punch['to'],
            project_id: punch['project']['id']
          }
        end
        expect(created_punches).to match_array(params[:punches])
      end
    end

    context 'when api token is valid, params are valid and has punches on the same day' do
      let!(:punch_1) { create(:punch, from: '2022-04-19T12:00:00', to: '2022-04-19T15:00:00', project: project, user: user) }
      let!(:punch_2) { create(:punch, from: '2022-04-19T16:00:00', to: '2022-04-19T21:00:00', project: project, user: user) }

      let(:params) {
        {
          "punches": [
            {
              "from": "2022-04-19T10:00:00.000Z",
              "to": "2022-04-19T12:00:00.000Z",
              "project_id": project.id
            },
            {
              "from": "2022-04-19T15:00:00.000Z",
              "to": "2022-04-19T20:00:00.000Z",
              "project_id": project.id
            }
          ]
        }
      }

      subject { post :create, params: params }
      before { request.headers.merge(headers) }

      include_examples 'an authenticated create resource action'

      it 'returns created punches and deletes the last punches' do
        expect(Punch.count).to eq(2)

        created_punches = JSON.parse(subject.body).map do |punch|
          {
            from: punch['from'],
            to: punch['to'],
            project_id: punch['project']['id']
          }
        end
        expect(created_punches).to match_array(params[:punches])

        expect(Punch.count).to eq(2)
      end
    end

    context 'when api token is missing' do
      subject { post :create }

      include_examples 'an unauthenticated resource action'
    end
  end
end
