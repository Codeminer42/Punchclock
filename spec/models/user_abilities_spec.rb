require 'spec_helper'
require 'cancan/matchers'

describe "User" do
	describe "abilities" do
		subject(:ability){ Ability.new(user) }
		let(:user){ nil }

		context "when is creating punches" do
			let(:user) { FactoryGirl.create(:user) }

			it { should be_able_to(:manage, Punch.new(company_id: user.company.id, user: User.new(company_id: user.company.id), project: Project.new(company_id: user.company.id))) }
			it { should_not be_able_to(:manage, Punch.new(company_id: user.company.id, user: User.new, project: Project.new(company_id: user.company.id))) }
			it { should_not be_able_to(:manage, Punch.new(company_id: user.company.id, user: User.new(company_id: user.company.id), project: Project.new)) }
			it { should_not be_able_to(:manage, Punch.new) }
		end
	end
end