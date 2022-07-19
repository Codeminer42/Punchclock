# frozen_string_literal: true
require  "#{Rails.root}/app/services/jwt/encode.rb"

module AuthHelper
  def api_auth(user)
    jwt_token = "Bearer #{Jwt::Encode.(user: user)}"
    # request.headers["Authorization"] = jwt_token
  end
end


RSpec.configure do |config|
  config.include AuthHelper
end
