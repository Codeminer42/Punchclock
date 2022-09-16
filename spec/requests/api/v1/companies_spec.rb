# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/companies', type: :request do
  path '/api/v1/users' do
    get('Returns company users') do
      tags 'Company users'
      security [bearer: []]
      produces 'application/json'

      response(200, 'ok') do
        let!(:company) { create(:company) }
        let!(:offices) { create_list(:office, 3, company: company) }
        let!(:user) { create(:user, company: company, office: offices.first) }
        let!(:Authorization) { "Bearer #{Jwt::Generate.new(user_id: user.id).token}" }

        examples 'application/json' => [{
          email: 'user.teste0@codeminer42.com',
          name: 'Usuario_Codeminer42_0',
          office_id: 10,
          github: 'Codeminer42.user.teste0'
        }]

        run_test!
      end

      response(401, 'Unauthorized') do
        let!(:company) { create(:company) }
        let!(:offices) { create_list(:office, 3, company: company) }
        let!(:user) { create(:user, company: company, office: offices.first) }
        let!(:Authorization) { nil }

        examples 'application/json' => {
          error: 'unauthorized'
        }

        run_test!
      end
    end
  end

  path '/api/v1/offices' do
    get('Returns company offices') do
      tags 'Company users'
      security [bearer: []]
      produces 'application/json'

      response(200, 'successful') do
        let!(:company) { create(:company) }
        let!(:offices) { create_list(:office, 3, company: company) }
        let!(:user) { create(:user, company: company, office: offices.first) }
        let!(:Authorization) { "Bearer #{Jwt::Generate.new(user_id: user.id).token}" }

        examples 'application/json' => [{
          id: 6,
          city: 'Natal',
          created_at: '2022-08-02T09:54:11.471-03:00',
          updated_at: '2022-08-02T09:54:11.471-03:00',
          company_id: 1,
          users_count: 0,
          score: nil,
          head_id: nil,
          active: true
        }]

        run_test!
      end

      response(401, 'Unauthorized') do
        let!(:company) { create(:company) }
        let!(:offices) { create_list(:office, 3, company: company) }
        let!(:user) { create(:user, company: company, office: offices.first) }
        let!(:Authorization) { nil }

        examples 'application/json' => {
          error: 'unauthorized'
        }

        run_test!
      end
    end
  end
end
