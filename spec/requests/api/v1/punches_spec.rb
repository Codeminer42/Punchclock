require 'swagger_helper'

RSpec.describe 'api/v1/punches', type: :request do

  before { create_logged_in_user }

  path '/api/v1/punches' do

    get('list punches') do
      response(200, 'successful') do

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
