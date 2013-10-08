class UsersController < InheritedResources::Base
	before_action :authenticate_user!
	load_and_authorize_resource

	def update
		if @user.update(user_params)
			flash.now[:notice] = "User updated successfully!"
		end
		render :edit
	end
private
	def user_params
		allow = [:name, :email]
		allow << :hour_cost if current_user.is_admin?
		params.require(:user).permit(allow)
	end
end
