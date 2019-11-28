# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create :user }
  let(:admin_user) { create :user, :admin}
  let(:super_admin) { create :user, :super_admin}
  let(:active_user) { create :user, :active_user }
  let(:inactive_user) { create :user, :inactive_user }

  describe 'associations' do
    it { is_expected.to belong_to(:office).optional }
    it { is_expected.to belong_to(:reviewer).optional }
    it { is_expected.to have_many(:punches) }
    it { is_expected.to have_many(:allocations) }
    it { is_expected.to have_many(:projects).through(:allocations) }
    it { is_expected.to have_and_belong_to_many(:skills) }
    it { is_expected.to have_many(:managed_offices).class_name('Office') }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:city).to(:office).with_prefix(true).allow_nil }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_presence_of(:occupation) }

    context 'When user is flagged as admin' do
      subject { build :user, admin: true }

      before { allow(subject).to receive(:admin?).and_return(true) }
    end

    context 'When user is not flagged as admin' do
      subject { build :user, admin: false }

      before { allow(subject).to receive(:admin?).and_return(false) }
    end
  end

  describe "occupation" do
    it { is_expected.to enumerize(:occupation).in(administrative: 0, engineer: 1) }

    context 'when user is engineer' do
      subject { build :user, occupation: 'engineer'}

      context 'level validation' do
        it { is_expected.to validate_presence_of(:level) }
      end

      context 'github validation' do
        it { is_expected.to validate_uniqueness_of(:github) }
      end
    end

    context 'when user is engineer with no level' do
      subject { build :user, occupation: 'engineer', level: '' }
      it { is_expected.to be_invalid }
    end
  end

  describe "specialty" do
    it { is_expected.to enumerize(:specialty).in( frontend: 0,
                                                  backend: 1,
                                                  devops: 2,
                                                  mobile: 4) }
  end

  describe "level" do
    it { is_expected.to enumerize(:level).in( trainee: 0,
                                              junior: 1,
                                              junior_plus: 2,
                                              mid: 3,
                                              mid_plus: 4,
                                              senior: 5,
                                              senior_plus: 6 ) }

  end

  describe 'contract type' do
    it { is_expected.to enumerize(:contract_type).in( internship: 0,
                                                      employee: 1,
                                                      contractor: 2,
                                                      associate: 3) }
  end

  describe 'role' do
    it { is_expected.to enumerize(:role).in(  normal: 0,
                                              evaluator: 1,
                                              admin: 2,
                                              super_admin: 3) }
  end

  describe 'scopes' do
    let(:user_not_in_experience){ create(:user, created_at: 5.months.ago)}
    let(:ruby)          { create(:skill, title: 'ruby') }
    let(:vuejs)         { create(:skill, title: 'vuejs') }
    let!(:full_stack)   { create(:user, skills: [ruby, vuejs]) }

    context '#by_skills' do
      it 'returns the users that have all the skills selected' do
        expect(User.by_skills_in(ruby.id, vuejs.id).first).to eq(full_stack)
      end
    end

    context '#not_in_experience' do
      it 'returns the user that are not in experience period' do
        expect(User.not_in_experience).to contain_exactly(user_not_in_experience)
      end
    end
  end

  context 'evaluations' do
    let(:user)           { create(:user) }
    let!(:evaluations) { create_list :evaluation, 2, :performance, evaluated: user }
    let!(:english_evaluation) { create(:evaluation, :english, english_level: 'beginner', evaluated: user) }

    describe '#ovelall_score_average' do
      subject { User.overall_score_average }

      before do
        allow(User).to receive(:all).and_return([user1, user2, user3])
      end

      context "all users with score" do
        let(:user1) { double(:user1, overall_score: 2.3) }
        let(:user2) { double(:user2, overall_score: 7.5) }
        let(:user3) { double(:user3, overall_score: 8) }

        it { is_expected.to eq(5.93) }
      end

      context "users with and without score" do
        let(:user1) { double(:user1, overall_score: 2.3) }
        let(:user2) { double(:user2, overall_score: nil) }
        let(:user3) { double(:user3, overall_score: 8) }

        it { is_expected.to eq(5.15) }
      end

      context "all users without score" do
        let(:user1) { double(:user1, overall_score: nil) }
        let(:user2) { double(:user2, overall_score: nil) }
        let(:user3) { double(:user3, overall_score: nil) }

        it { is_expected.to eq(0) }
      end
    end

    describe '#english_level' do
      let!(:new_evaluation) { create(:evaluation, :english, english_level: 'advanced', evaluated: user) }

      it 'returns the english level from the users last english evaluation' do
        expect(user.english_level).to eq('advanced')
      end
    end

    describe '#english_score' do
      it 'returns the user average score of all performance evaluations' do
        expect(user.english_score).to eq(english_evaluation.score)
      end
    end

    describe '#performance_score' do
      it 'returns the user average score of all performance evaluations' do
        expect(user.performance_score).to eq(evaluations.sum(&:score) / evaluations.count.to_f)
      end
    end

    describe '#overall_score' do
      it 'returns the user average score of all performance evaluations' do
        expect(user.overall_score).to eq((user.performance_score + english_evaluation.score)/2.0)
      end
    end
  end

  context 'allocations' do
    let(:user)           { create(:user) }
    let!(:allocation) { create(:allocation, :with_end_at, user: user) }

    it 'returns the user allocated project' do
      expect(user.current_allocation).to eq(allocation.project)
    end
  end

  describe 'managed offices' do
    let(:user)   { create(:user) }
    let(:office)  { create(:office, head: user) }
    let(:office2) { create(:office, head: user) }

    it 'returns all offices the user is head' do
      expect(user.managed_offices).to contain_exactly(office, office2)
    end
  end

  describe '#office_head?' do
    let(:user)   { create(:user) }

    context 'when user is not head' do
      it 'returns false' do
        expect(user).to_not be_office_head
      end
    end

    context 'when user is head' do
      let!(:office) { create(:office, head: user) }

      it 'returns true' do
        expect(user).to be_office_head
      end
    end
  end

  describe '#enable!' do
    it 'enables a user' do
      inactive_user.enable!
      expect(inactive_user).to be_active
    end
  end

  describe '#disable!' do
    it 'disables a user' do
      active_user.disable!
      expect(active_user).not_to be_active
    end
  end

  describe '#to_s' do
    it { expect(user.to_s).to eq user.name }
  end

  describe '#active_for_authentication' do
    it { expect(active_user).to be_active_for_authentication }
    it { expect(inactive_user).not_to be_active_for_authentication }
  end

  describe '#inactive_message' do
    it { expect(inactive_user.inactive_message).to eq :inactive_account }
    it { expect(active_user.inactive_message).to eq :unconfirmed }
  end

  describe '#access_admin' do
    it "allows admin access for user with admin role" do
      expect(admin_user).to have_admin_access
    end

    it "allow admin access for user with super_admin role" do
      expect(super_admin).to have_admin_access
    end

    it "not allows admin access for user without admin or super_admin roles" do
      expect(user).to_not have_admin_access
    end
  end
end
