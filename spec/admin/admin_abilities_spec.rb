require 'spec_helper'
require 'cancan/matchers'

describe "AdminUser" do
	describe "abilities" do
		subject(:ability){ Ability.new(user) }
		let(:user){ nil }

		context "when is an account manager" do
			let(:user) { FactoryGirl.create(:admin_user) }

			it { should be_able_to(:manage, Company.find(user.company.id)) }
			it { should_not be_able_to(:manage, Company.new) }
			it { should be_able_to(:manage, AdminUser.new(company_id: user.company.id)) }
			it { should_not be_able_to(:manage, AdminUser.new(company_id: user.company.id, is_super:true)) }
			it { should_not be_able_to(:manage, AdminUser.new) }
		end

		context "when is an super account manager" do
			let(:user) { FactoryGirl.create(:super) }

			it { should be_able_to(:manage, AdminUser.new) }
			it { should be_able_to(:manage, Company.new) }
			it { should be_able_to(:manage, Project.new) }
			it { should be_able_to(:manage, User.new) }
			it { should be_able_to(:manage, Punch.new) }
		end
	end
end