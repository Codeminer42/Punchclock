module Users
  class RegistrationsController < Devise::RegistrationsController
    private

    def build_resource(user_params)
      super({
        company: Company.new,
        is_admin: true
      }.merge user_params)
    end

    def sign_up_params
      params.require(:user).permit([
        :name,
        :email,
        :password,
        :password_confirmation,
        company_attributes: [:name]
      ])
    end

    def sign_up(resource_name, resource)
      NotificationMailer.notify_successful_signup(resource).deliver
      super
    end
  end
end
