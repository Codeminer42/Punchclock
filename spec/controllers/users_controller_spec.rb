require 'spec_helper'

describe UsersController do
	login_user

	describe "PUT update" do
		let(:user) { FactoryGirl.create(:user) }

		before do
			User.stub(:find).with(user.id.to_s) { user }
			controller.stub(load_and_authorize_resource: true)
			controller.stub(current_user: user)
			user.stub(is_admin?: true)
		end

		context "with valid informations" do
			it "should update user" do
				params = {
					id: user.id,
					user: { name: '1234', email: '1234@1234.com'}
				}

				expect(user).to receive(:update).and_return(true)
				put :update, params
				expect(response).to render_template :edit
			end
		end

		context "with invalid informations" do
			it "should update user" do
				params = {
					id: user.id,
					user: { name: '', email: '1234@1234.com'}
				}

				expect(user).to receive(:update).and_return(false)
				put :update, params
				expect(response).to render_template :edit
			end
		end
	end
end
