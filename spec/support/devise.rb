# frozen_string_literal: true
module SessionMacros
  def login(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end

  def login_user
    before { login create :user }
  end
end

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Warden::Test::Helpers, type: :feature
  config.extend SessionMacros, type: :controller
  config.before(type: :request) { Warden.test_mode! }
end
