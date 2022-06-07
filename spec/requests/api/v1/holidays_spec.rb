require 'swagger_helper'

RSpec.describe 'api/v1/holidays', type: :request do
  
  before { create_logged_in_user }

  path '/api/v1/holidays' do

    get('list holidays') do
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
