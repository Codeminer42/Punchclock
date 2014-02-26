module RequestHelpers
  def create_logged_in_user(*options)
    user = FactoryGirl.create(:user, *options)
    login(user)
    user
  end
  
  def login(user)
    login_as user, scope: :user
  end
end