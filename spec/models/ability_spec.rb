require 'spec_helper'
require 'cancan/matchers'

describe 'User' do
  let(:user) { FactoryGirl.build(:user, id: 1) }
  subject(:ability) { Ability.new(user) }

  describe 'abilities' do
    context 'when is creating punches' do
      it do
        is_expected.to be_able_to(
          :manage, Punch.new(company_id: user.company.id, user_id: user.id)
        )
      end
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

    context 'when is managing Comments' do
      it do
        is_expected.to be_able_to(
          :manage, Comment.new(user_id: user.id, company_id: user.company_id)
        )
      end
    end
  end

  describe 'admin abilities' do
    let(:user) { FactoryGirl.build(:user, is_admin: true) }
    subject(:ability) { Ability.new(user) }

    context 'when is creating projects' do
      it do
        is_expected.to be_able_to(:manage, Project.new(company_id: user.company.id))
      end
      it { is_expected.not_to be_able_to(:manage, Project.new) }
    end

    context 'when updating your own company' do
      let(:company) { FactoryGirl.build(:company) }
      it { is_expected.to be_able_to(:read, user.company) }
      it { is_expected.to be_able_to(:update, user.company) }
      it { is_expected.not_to be_able_to(:create, Company.new) }
      it { is_expected.not_to be_able_to(:destroy, user.company) }
      it { is_expected.not_to be_able_to(:manage, company) }
    end

    context 'when is managing Users' do
      it { is_expected.to be_able_to(:manage, User.new(company_id: user.company.id)) }
      it { is_expected.not_to be_able_to(:manage, User.new) }
    end

    context 'when is managing Comments' do
      it { is_expected.to be_able_to(:read, Comment.new(company_id: user.company_id)) }
      it do
        is_expected.to be_able_to(:manage, Comment.new(company_id: user.company_id))
      end
      it { is_expected.not_to be_able_to(:manage, Comment.new) }
    end
  end

  describe 'shared abilities' do
    it { is_expected.to be_able_to(:read, Notification.new(user_id: user.id)) }
    it { is_expected.not_to be_able_to(:read, Notification.new) }
    it { is_expected.to be_able_to(:update, Notification.new(user_id: user.id)) }
    it { is_expected.not_to be_able_to(:update, Notification.new) }
  end
end
