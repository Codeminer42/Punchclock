require 'spec_helper'

describe PasswordsController do
	login_user

	describe "PATCH update" do
		let(:user) { FactoryGirl.build(:user) }

		before do
			controller.stub(current_user: user)
		end

		describe "when user update your account" do
			context "with correct authorization" do
				before do
					user.stub(id: 1)
				end

				context "with valid password" do
					it "update your password" do
						params = { id: 1,
											 user: { "current_password" => 'password',
											 				 "password" => '12345678',
											 				 "password_confirmation" => '12345678'
											       }
										 }

						user.stub(current_password:'password')
						expect(user).to receive(:update_with_password).with(params[:user]).and_return(true)

						patch :update, params
						expect(response).to redirect_to edit_user_path(user)
					end
				end

				context "with invalid password" do
					it "update your password" do
						params = { id: 1,
											 user: { "current_password" => 'password',
											 				 "password" => '',
											 				 "password_confirmation" => '12345678'
											       }
										 }

						user.stub(current_password:'password')
						expect(user).to receive(:update_with_password).with(params[:user]).and_return(false)

						patch :update, params
						expect(response).to render_template(:edit)
					end
				end
			end
		end
	end
end
