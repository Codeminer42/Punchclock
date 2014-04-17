def login user
  @request.env['devise.mapping'] = Devise.mappings[:user]
  sign_in user
end

module ControllerMacros
  def login_user
    before { login create :user }
  end
end
