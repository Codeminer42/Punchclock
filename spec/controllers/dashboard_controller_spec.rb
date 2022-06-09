require 'rails_helper'

RSpec.describe DashboardController, type: :controller do  
  describe 'POST #save' do
    let(:user) { create(:user) }
    let(:project) { create(:project, company: user.company) }

    before { login(user) }

    subject { post :save, params: punch_params }

    context 'when work periods are valid' do

      let(:punch_params) do
        morning_period, lunch_period = [
          { from: "2022-05-16T09:00:00.000Z", to: "2022-05-16T12:00:00.000Z", project_id: project.id, delta: 0 },
          { from: "2022-05-16T13:00:00.000Z", to: "2022-05-16T18:00:00.000Z", project_id: project.id, delta: 0 }
        ]

        { delete: ["2022-05-16"], add: { "2022-05-16": [morning_period, lunch_period] } }
      end

      it 'returns created http status' do
        subject
        expect(response).to have_http_status(:created)
      end
    end

    context 'when work periods are invalid' do
      context 'when both periods are equal' do
        let(:punch_params) do
          morning_period, lunch_period = [
            { from: "2022-05-16T09:00:00.000Z", to: "2022-05-16T09:00:00.000Z", project_id: project.id, delta: 0 },
            { from: "2022-05-16T09:00:00.000Z", to: "2022-05-16T09:00:00.000Z", project_id: project.id, delta: 0 }
          ]

          { delete: ["2022-05-16"], add: { "2022-05-16": [morning_period, lunch_period] } }
        end
  
        it 'returns bad request http status' do
          subject
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'when from hour is greater than to hour' do
        let(:punch_params) do
          morning_period, lunch_period = [
            { from: "2022-05-16T09:00:00.000Z", to: "2022-05-16T08:00:00.000Z", project_id: project.id, delta: 0 },
            { from: "2022-05-16T13:00:00.000Z", to: "2022-05-16T18:00:00.000Z", project_id: project.id, delta: 5 }
          ]

          { delete: ["2022-05-16"], add: { "2022-05-16": [morning_period, lunch_period] } }
        end
  
        it 'returns bad request http status' do
          subject
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'when morning from hour is greater than lunch to hour' do
        let(:punch_params) do
          morning_period, lunch_period = [
            { from: "2022-05-16T14:00:00.000Z", to: "2022-05-16T12:00:00.000Z", project_id: project.id, delta: 0 },
            { from: "2022-05-16T12:00:00.000Z", to: "2022-05-16T18:00:00.000Z", project_id: project.id, delta: 5 }
          ]

          { delete: ["2022-05-16"], add: { "2022-05-16": [morning_period, lunch_period] } }
        end
  
        it 'returns bad request http status' do
          subject
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end
end
