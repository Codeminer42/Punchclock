class UsersController < InheritedResources::Base
	before_action :authenticate_user!
	load_and_authorize_resource except: [:create]

private
	def user_params
		allow = [:name, :email, :password, :password_confirmation]
		params.require(:user).permit(allow)
	end
end
