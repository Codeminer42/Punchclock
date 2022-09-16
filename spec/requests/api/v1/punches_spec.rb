# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/punches', type: :request do
  path '/api/v1/punches/bulk' do
    post('bulk punch') do
      tags 'Punches'
      security [bearer: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :punches, in: :body, schema: {
        type: :object,
        properties: {
          punches: {
            type: :array,
            items: {
              type: :object,
              properties: {
                from: {
                  type: :string,
                  example: '2022-04-20T12:00:00.000Z'
                },
                to: {
                  type: :string,
                  example: '2022-04-20T15:00:00.000Z'
                },
                project_id: {
                  type: :integer,
                  example: 1
                }
              }
            }
          }
        }
      }

      response(201, 'created') do
        let!(:user) { create(:user) }
        let!(:project) { create(:project) }
        let!(:Authorization) { "Bearer #{Jwt::Generate.new(user_id: user.id).token}" }
        let!(:punches) do
          {
            'punches' => [
              { from: '2022-04-20T12:00:00.000Z', to: '2022-04-20T15:00:00.000Z', project_id: project.id }
            ]
          }
        end

        examples 'application/json' => [{
          created_at: '2022-08-02T16:11:46.215-03:00',
          from: '2022-04-20T09:00:00.000-03:00',
          to: '2022-04-20T12:00:00.000-03:00',
          delta_as_hour: '03:00',
          extra_hour: false,
          project: {
            id: 2,
            name: 'Rito Gomes'
          }
        }]

        run_test!
      end

      response(401, 'Unauthorized') do
        let!(:user) { create(:user) }
        let!(:project) { create(:project) }
        let!(:Authorization) { nil }
        let!(:punches) do
          {
            'punches' => [
              { from: '2022-04-20T12:00:00.000Z', to: '2022-04-20T15:00:00.000Z', project_id: project.id }
            ]
          }
        end

        examples 'application/json' => {
          error: 'unauthorized'
        }

        run_test!
      end

      response(422, 'Unprocessable entity') do
        let!(:user) { create(:user) }
        let!(:project) { create(:project) }
        let!(:Authorization) { "Bearer #{Jwt::Generate.new(user_id: user.id).token}" }
        let!(:punches) do
          {
            'punches' => [
              {}
            ]
          }
        end

        run_test!
      end
    end
  end

  path '/api/v1/punches' do
    get('list punches') do
      tags 'Punches'
      security [bearer: []]
      produces 'application/json'

      response(200, 'ok') do
        let!(:user) { create(:user) }
        let!(:Authorization) { "Bearer #{Jwt::Generate.new(user_id: user.id).token}" }
        let!(:punch) { create(:punch, user_id: user.id) }

        examples 'application/json' => [{
          created_at: '2022-08-02T14:37:21.846-03:00',
          from: '2022-08-01T13:00:00.000-03:00',
          to: '2022-08-01T18:00:00.000-03:00',
          delta_as_hour: '05:00',
          extra_hour: false,
          project: {
            id: 2,
            name: 'Rito Gomes'
          }
        }]

        run_test!
      end

      response(401, 'Unauthorized') do
        let!(:user) { create(:user) }
        let!(:project) { create(:project) }
        let!(:Authorization) { nil }
        let!(:punch) { create(:punch, user_id: user.id) }

        examples 'application/json' => {
          error: 'unauthorized'
        }

        run_test!
      end
    end
  end

  path '/api/v1/punches/{id}' do
    get('show punch') do
      tags 'Punches'
      security [bearer: []]
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response(302, 'Found') do
        let!(:user) { create(:user) }
        let!(:Authorization) { "Bearer #{Jwt::Generate.new(user_id: user.id).token}" }
        let!(:punch) { create(:punch, user_id: user.id) }
        let!(:id) { punch.id }

        examples 'application/json' => {
          created_at: '2022-08-02T14:37:21.846-03:00',
          from: '2022-08-01T13:00:00.000-03:00',
          to: '2022-08-01T18:00:00.000-03:00',
          delta_as_hour: '05:00',
          extra_hour: false,
          project: {
            id: 2,
            name: 'Rito Gomes'
          }
        }

        run_test!
      end

      response(401, 'Unauthorized') do
        let!(:user) { create(:user) }
        let!(:Authorization) { nil }
        let!(:punch) { create(:punch, user_id: user.id) }
        let!(:id) { punch.id }

        examples 'application/json' => {
          error: 'unauthorized'
        }

        run_test!
      end
    end
  end
end
