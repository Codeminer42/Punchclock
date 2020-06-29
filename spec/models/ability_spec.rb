require 'spec_helper'
require 'cancan/matchers'

describe 'User' do
  let(:admin_user) { create(:user, :admin) }
  let(:admin_user_super) { create(:user, :super_admin, occupation: :administrative) }
  let(:open_source_manager_user) { create(:user, :open_source_manager) }
  let(:user) { FactoryBot.build(:user, id: 1) }
  subject(:ability) { Ability.new(user) }
 
  describe 'abilities admin' do
    let(:ability_admin) { Ability.new(admin_user) }

    it "can manage it's own punches" do
      expect(ability_admin).to be_able_to :manage, Punch.new(user: admin_user)
    end

    it "can't delete Company" do
     expect(ability_admin).to_not be_able_to :destroy, Company.new
    end

    it "can't delete Projects" do
     expect(ability_admin).to_not be_able_to :destroy, Project.new
    end
  
    it "can't edit punch" do
      expect(ability_admin).to_not be_able_to :edit, Punch.new
    end

    it "can't delete punch" do
      expect(ability_admin).to_not be_able_to :destroy, Punch.new
    end

    it "can't manage Company" do
     expect(ability_admin).to_not be_able_to :manage, Company.new
    end
  end

  describe 'abilities super admin' do
    let(:ability_admin_super) { Ability.new(admin_user_super) }

    it 'able to manage punch' do
      expect(ability_admin_super).to be_able_to :manage, Punch.new
    end

    it 'able to manage Company' do
     expect(ability_admin_super).to be_able_to :manage, Company.new
    end

    it 'able to manage Projects' do
     expect(ability_admin_super).to be_able_to :manage, Project.new
    end
  end

  describe 'abilities open source manager' do
    let(:ability_open_source_manager) { Ability.new(open_source_manager_user) }

    it 'able to manage Repository' do
      expect(ability_open_source_manager).to be_able_to :manage, Repository
    end

    it 'able to manage Contribution' do
      expect(ability_open_source_manager).to be_able_to :manage, Contribution
    end

    it 'able to read dashboard' do
      expect(ability_open_source_manager).to be_able_to :read, ActiveAdmin::Page, name: "Dashboard"
    end

    it "can't manage User on active admin" do
      expect(ability_open_source_manager).to_not be_able_to :manage, User
    end
  end

  describe 'abilities user' do
    context 'when is creating punches' do
      it { is_expected.not_to be_able_to(:manage, Punch.new) }
    end

    context 'when is trying to manage Company' do
      it { is_expected.not_to be_able_to(:manage, Company.new) }
    end

    context 'when is trying to manage Projects' do
      it { is_expected.not_to be_able_to(:manage, Project.new) }
    end

    context 'when is trying to perform operations on Users' do
      it { is_expected.to be_able_to(:read, User.new(company_id: user.company.id)) }
      it { is_expected.not_to be_able_to(:read, User.new) }
      it { is_expected.to be_able_to(:edit, User.new(id: user.id)) }
      it { is_expected.not_to be_able_to(:edit, User.new) }
      it { is_expected.to be_able_to(:update, User.new(id: user.id)) }
      it { is_expected.not_to be_able_to(:update, User.new) }
    end
  end
end
