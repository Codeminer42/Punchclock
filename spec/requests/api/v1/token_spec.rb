# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/token', type: :request do
  path '/api/v1/request' do
    post('request token') do
      tags 'Token'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          email: {
            type: :string,
            example: 'admin@codeminer42.com'
          },
          password: {
            type: :string,
            example: 'password'
          }
        },
        required: %i[email password]
      }

      response(201, 'created') do
        let!(:user) { create(:user) }
        let(:params) { { email: user.email, password: user.password } }

        examples 'application/json' => {
          access_token: 'eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2NjAwNzM3MjQsInN1YiI6MiwiZW52IjoiZGV2ZWxvcG1lbnQiLCJqdGkiOiI5MTQ2MGUzMC01Y2U2LTQyNTEtYjNmOC0yNDk4OWZhOTM0YWEifQ.6JquPRqkTGGn4IMrLdjqHqsyjl71GxB-nDB7ZohPcv8'
        }

        run_test!
      end

      response(422, 'Unprocessable entity') do
        let!(:user) { create(:user) }
        let(:params) { { email: user.email, password: 'not a password' } }

        examples 'application/json' => {
          error: 'Usuário ou Senha incorretos'
        }

        run_test!
      end
    end
  end

  path '/api/v1/refresh' do
    post('refresh token') do
      tags 'Token'
      produces 'application/json'
      security [bearer: []]

      response(201, 'created') do
        let!(:user) { create(:user) }
        let!(:Authorization) { "Bearer #{Jwt::Generate.new(user_id: user.id).token}" }

        examples 'application/json' => {
          access_token: 'eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2NjAwNzM3MjQsInN1YiI6MiwiZW52IjoiZGV2ZWxvcG1lbnQiLCJqdGkiOiI5MTQ2MGUzMC01Y2U2LTQyNTEtYjNmOC0yNDk4OWZhOTM0YWEifQ.6JquPRqkTGGn4IMrLdjqHqsyjl71GxB-nDB7ZohPcv8'
        }

        run_test!
      end

      response(401, 'Unprocessable entity') do
        let!(:user) { create(:user) }
        let!(:Authorization) { nil }

        examples 'application/json' => {
          error: 'unauthorized'
        }

        run_test!
      end
    end
  end
end
