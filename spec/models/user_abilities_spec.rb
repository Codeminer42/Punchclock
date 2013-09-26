require 'spec_helper'
require 'cancan/matchers'

describe "User" do
	describe "user abilities" do
		let(:user) { FactoryGirl.build(:user) }
		subject(:ability){ UserAbility.new(user) }

		context "when is creating punches" do
			it { should be_able_to(:manage, Punch.new(company_id: user.company.id, user: User.new(company_id: user.company.id), project: Project.new(company_id: user.company.id))) }
			it { should_not be_able_to(:manage, Punch.new(company_id: user.company.id, user: User.new, project: Project.new(company_id: user.company.id))) }
			it { should_not be_able_to(:manage, Punch.new(company_id: user.company.id, user: User.new(company_id: user.company.id), project: Project.new)) }
			it { should_not be_able_to(:manage, Punch.new) }
		end

		context "when is trying to manage Company" do
			it { should_not be_able_to(:manage, Company.new) }
		end

		context "when is trying to manage Users" do
			it { should be_able_to(:read, User.new(company_id: user.company.id)) }
			it { should_not be_able_to(:read, User.new) }
			it { should_not be_able_to(:manage, User.new) }
			it { should be_able_to(:create, User.new(company_id: user.company.id)) }
			it { should_not be_able_to(:create, User.new) }
		end
	end

	describe "user admin abilities" do
		let(:user) { FactoryGirl.build(:user, is_admin: true) }
		subject(:ability){ UserAbility.new(user) }

		context "when is creating projects" do
			it { should be_able_to(:manage, Project.new(company_id: user.company.id)) }
			it { should_not be_able_to(:manage, Project.new) }
		end

		context "when updating your own company" do
			let(:company) { FactoryGirl.build(:company) }
			it { should be_able_to(:read, user.company) }
			it { should be_able_to(:update, user.company) }
			it { should_not be_able_to(:create, Company.new) }
			it { should_not be_able_to(:destroy, user.company) }
			it { should_not be_able_to(:manage, company) }
		end

		context "when is managing Users" do
			it { should be_able_to(:manage, User.new(company_id: user.company.id)) }
			it { should_not be_able_to(:manage, User.new) }
		end
	end
end