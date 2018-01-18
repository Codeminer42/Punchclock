require 'spec_helper'
require 'cancan/matchers'

describe 'User' do	
  let(:admin_user) { FactoryBot.create(:admin_user) } 
  let(:admin_user_super) { FactoryBot.create(:super) }
  let(:user) { FactoryBot.build(:user, id: 1) }
  subject(:ability) { Ability.new(user) }
 
  describe 'abilities admin' do
    let(:ability_admin) { Ability.new(admin_user) }

    it 'cant delete punch' do
      ability_admin.should_not be_able_to(:destroy, Punch.new)
    end

    it 'cant delete Company' do
     ability_admin.should_not be_able_to(:destroy, Company.new)
    end

    it 'cant delete Projects' do
     ability_admin.should_not be_able_to(:destroy, Project.new)
    end
  
    it 'can edit punch' do
      ability_admin.should_not be_able_to(:edit, Punch.new)
    end

    it 'can edit Company' do
     ability_admin.should_not be_able_to(:destroy, Company.new)
    end

    it 'can edit Projects' do
     ability_admin.should_not be_able_to(:destroy, Project.new)
    end
  end

  describe 'abilities super  admin' do
    let(:ability_admin_super) { Ability.new(admin_user_super) }

    it 'able to manage punch' do
      ability_admin_super.should be_able_to(:destroy, Punch.new)
    end

    it 'when is trying to manage Company' do
     ability_admin_super.should be_able_to(:destroy, Company.new)
    end

    it 'when is trying to manage Projects' do
     ability_admin_super.should be_able_to(:destroy, Project.new)
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
