require 'spec_helper'

describe UserAccountController do
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

				context "with valid data for name" do
					it "update your name" do
						params = { id: 1, user: { "name" => 'Joselito' } }

						expect(user).to receive(:update).with(params[:user]).and_return(true)

						patch :update, params
						expect(response).to render_template(:edit)
					end
				end

				context "with invalid data for name" do
					it "does not update" do
						params = { id: 1, user: { "name" => '' } }

						expect(user).to receive(:update).with(params[:user]).and_return(false)

						patch :update, params
						expect(response).to render_template(:edit)
					end
				end

				context "with valid data for email" do
					it "update your name" do
						params = { id: 1, user: { "email" => 'Joselito@jose.com' } }

						expect(user).to receive(:update).with(params[:user]).and_return(true)

						patch :update, params
						expect(response).to render_template(:edit)
					end
				end

				context "with invalid data for email" do
					it "does not update" do
						params = { id: 1, user: { "email" => '@jose' } }

						expect(user).to receive(:update).with(params[:user]).and_return(false)

						patch :update, params
						expect(response).to render_template(:edit)
					end
				end

			end

			context "with incorrect authorization" do
				before do
					user.stub(id: 42)
				end

				it "fails to update" do
					params = { id: 1, user: { "name" => 'Joselito' } }

					expect(user).not_to receive(:update)

					patch :update, params
					expect(response).to redirect_to(root_url)
				end
			end
		end
	end
end
