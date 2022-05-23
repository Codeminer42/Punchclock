require 'spec_helper'
require 'swagger_helper'
require 'pry'
RSpec.describe 'api/v1/holidays', type: :request do
  let(:user) { create(:user, :with_token) }
  let(:headers) { { token: user.token } }
  
  path '/api/v1/holidays' do
    it 'should have user' do
      binding.pry
    end
    get('holidays_dashboard holiday') do
      produces 'application/json'
      security [ basicAuth: [] ]
      response(200, 'successful') do
        let(:Authorization) { 'Bearer ' + headers[:token] }
        examples 'application/json' => [{
          month: 6,
          day: 3
        }]
        # after do |example|
        #   example.metadata[:response][:content] = {
        #     'application/json' => {
        #       example: JSON.parse(response.body, symbolize_names: true)
        #     }
        #   }
        # end
        run_test!
      end
    end
  end
end
