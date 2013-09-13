require 'spec_helper'

describe UsersController do
	login_user

	describe "PATCH update_user" do
		let(:user) { controller.current_user }

		describe "when user update your account" do
			it "update your name" do
				user_params = {
					name: 'Joselito'
				}
				params = {
					user: user_params
				}
			end
		end

		describe "when user account update fails" do
		end
	end
end
