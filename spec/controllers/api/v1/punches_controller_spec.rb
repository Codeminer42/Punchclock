require 'spec_helper'

describe Api::V1::PunchesController, :type => :controller do
  let(:company) { create(:company) }
  let(:user) { create(:user, :with_token, company: company) }
  let(:project) { create(:project, company: user.company) }
  let(:headers) { { token: user.token } }

  describe 'POST api/v1/punches', :fast => true do
    context 'when api token is valid and params are valid' do
      let(:params) {
        {
          "punches": {
            "2022-04-19": [
              {
                "from": "2022-04-19T12:00:00.000Z",
                "to": "2022-04-19T15:00:00.000Z",
                "project_id": "#{project.id}"
              },
              {
                "from": "2022-04-19T16:00:00.000Z",
                "to": "2022-04-19T21:00:00.000Z",
                "project_id": "#{project.id}"
              }
            ]
          }
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
        created_punches = JSON.parse(subject.body).map { |punch| {from: punch['from'], to: punch['to'], project_id: punch['project_id'].to_s } }
        expected_punches = params[:punches].values.flatten.map { |punch| {from: punch[:from], to: punch[:to], project_id: punch[:project_id].to_s } }
        expect(created_punches).to match_array(expected_punches)
      end
    end

    context 'when api token is valid, params are valid and has punches on the same day' do
      let(:first_request_params) {
        {
          "punches": {
            "2022-04-19": [
              {
                "from": "2022-04-19T12:00:00.000Z",
                "to": "2022-04-19T15:00:00.000Z",
                "project_id": "#{project.id}"
              },
              {
                "from": "2022-04-19T16:00:00.000Z",
                "to": "2022-04-19T21:00:00.000Z",
                "project_id": "#{project.id}"
              }
            ]
          }
        }
      }

      let(:second_request_params) {
        {
          "punches": {
            "2022-04-19": [
              {
                "from": "2022-04-19T10:00:00.000Z",
                "to": "2022-04-19T12:00:00.000Z",
                "project_id": "#{project.id}"
              },
              {
                "from": "2022-04-19T15:00:00.000Z",
                "to": "2022-04-19T20:00:00.000Z",
                "project_id": "#{project.id}"
              }
            ]
          }
        }
      }

      let(:first_request) { post :create, params: first_request_params }
      let(:second_request) { post :create, params: second_request_params }

      before do
        request.headers.merge(headers)
      end

      it 'returns content type json' do
        expect(first_request.content_type).to eq 'application/json; charset=utf-8'
        expect(second_request.content_type).to eq 'application/json; charset=utf-8'
      end

      it 'returns created punches and deletes the last punches' do
        first_request_punches = JSON.parse(first_request.body)
        first_created_punches = first_request_punches.map { |punch| {from: punch['from'], to: punch['to'], project_id: punch['project_id'].to_s } }
        first_expected_punches = first_request_params[:punches].values.flatten.map { |punch| {from: punch[:from], to: punch[:to], project_id: punch[:project_id].to_s } }
        expect(first_created_punches).to match_array(first_expected_punches)

        first_request_punches_ids = first_request_punches.map { |punch| punch['id'] }
        first_created_punches = Punch.find(first_request_punches_ids)

        second_request_punches = JSON.parse(second_request.body)
        second_created_punches = second_request_punches.map { |punch| {from: punch['from'], to: punch['to'], project_id: punch['project_id'].to_s } }
        second_expected_punches = second_request_params[:punches].values.flatten.map { |punch| {from: punch[:from], to: punch[:to], project_id: punch[:project_id].to_s } }
        expect(second_created_punches).to match_array(second_expected_punches)

        first_created_punches.each do |punch|
          expect { punch.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context 'when api token is valid, but does not have punches' do
      let(:params) {
        {
          "punches": {}
        }
      }

      subject { post :create, params: params }

      before do
        request.headers.merge(headers)
      end

      it { is_expected.to have_http_status(:bad_request) }

      it 'returns content type json' do
        expect(subject.content_type).to eq 'application/json; charset=utf-8'
      end

      it 'returns a missing punches message' do
        expect(JSON.parse(subject.body)).to eq('message' => 'There are no punches to create')
      end
    end

    context 'when api token is valid, but does not have params' do
      subject { post :create }

      before do
        request.headers.merge(headers)
      end

      it { is_expected.to have_http_status(:bad_request) }

      it 'returns content type json' do
        expect(subject.content_type).to eq 'application/json; charset=utf-8'
      end

      it 'returns a missing punches message' do
        expect(JSON.parse(subject.body)).to eq('message' => 'There are no punches to create')
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
