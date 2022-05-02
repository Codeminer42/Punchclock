require 'spec_helper'

describe Api::V1::PunchesController, :type => :controller do
  let(:company) { create(:company) }
  let(:user) { create(:user, :with_token, company: company) }
  let(:project) { create(:project, company: user.company) }
  let(:headers) { { token: user.token } }

  describe 'POST api/v1/punches', fast: true do
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

      before do
        request.headers.merge(headers)
      end

      it { is_expected.to have_http_status(:created) }

      it 'returns content type json' do
        expect(subject.content_type).to eq 'application/json; charset=utf-8'
      end

      it 'returns created punches' do
        created_punches = JSON.parse(subject.body).map { |punch| punch.slice('from', 'to', 'project_id').symbolize_keys }
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

      before do
        request.headers.merge(headers)
      end

      it { is_expected.to have_http_status(:created) }

      it 'returns content type json' do
        expect(subject.content_type).to eq 'application/json; charset=utf-8'
      end

      it 'returns created punches and deletes the last punches' do
        expect(Punch.count).to eq(2)

        created_punches = JSON.parse(subject.body).map { |punch| punch.slice('from', 'to', 'project_id').symbolize_keys }
        expect(created_punches).to match_array(params[:punches])

        expect(Punch.count).to eq(2)
      end
    end

    context 'when api token is missing' do
      subject { post :create }

      it { is_expected.to have_http_status(:unauthorized) }

      it 'returns content type json' do
        expect(subject.content_type).to eq 'application/json; charset=utf-8'
      end

      it 'returns a missing token message' do
        expect(JSON.parse(subject.body)).to eq('message' => 'Missing Token')
      end
    end
  end
end
