module RequestHelpers
  def create_logged_in_user(*options)
    user = FactoryBot.create(:user, *options)
    login(user)
    user
  end

  def login(user)
    login_as user, scope: :user
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request
  config.include RequestHelpers, type: :feature
end
