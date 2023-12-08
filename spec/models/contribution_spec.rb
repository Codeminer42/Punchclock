# frozen_string_literal: true

require 'rails_helper'
require 'aasm/rspec'

RSpec::Matchers.define_negated_matcher :not_include, :include

RSpec.describe Contribution, type: :model do
  it { is_expected.to belong_to(:repository) }
  it { is_expected.to belong_to(:reviewed_by).class_name('User').optional }
  it { is_expected.to belong_to(:reviewed_by).class_name('User').optional }
  it { is_expected.to have_and_belong_to_many(:users) }
  it { is_expected.to validate_presence_of :link }
  it { is_expected.to validate_presence_of :state }

  describe 'defaults' do
    context 'after the contribution is created' do
      subject(:contribution) { build(:contribution) }

      it 'has received state' do
        expect(contribution).to have_state(:received)
      end
    end
  end

  describe 'states' do
    subject(:contribution) { build(:contribution) }
    let(:reviewer) { create(:user) }

    context 'when the contribution is created' do
      it 'has state received' do
        expect(contribution).to have_state(:received)
      end

      it 'can transition to approved' do
        expect(contribution).to transition_from(:received).to(:approved)
                                                          .on_event(:approve, reviewer.id)
      end

      it 'can transition to refused' do
        expect(contribution).to transition_from(:received).to(:refused)
                                                          .on_event(:refuse, reviewer.id)
      end
    end

    context 'when the contribution is approved' do
      before do
        travel_to Time.zone.parse('2022-01-01')
      end

      it 'has state approved' do
        expect do
          contribution.approve(reviewer.id)
        end.to change { contribution.state }.from('received').to('approved')
      end

      it 'updates reviewer_id' do
        expect do
          contribution.approve(reviewer.id)
        end.to change { contribution.reviewer_id }.from(nil).to(reviewer.id)
      end

      it 'updates reviewed_at' do
        expect do
          contribution.approve(reviewer.id)
        end.to change { contribution.reviewed_at }.from(nil).to(Time.current)
      end

      it 'updates tracking' do
        expect do
          contribution.approve(reviewer.id)
        end.to change { contribution.tracking }.from(false).to(true)
      end
    end

    context 'when the contribution is refused' do
      before do
        travel_to Time.zone.parse('2022-01-01')
        contribution.refuse(reviewer.id)
      end

      it 'has state refused' do
        expect(contribution).to have_state(:refused)
      end

      it 'updates reviewer_id' do
        expect(contribution.reviewer_id).to be(reviewer.id)
      end

      it 'updates reviewed_at' do
        expect(contribution.reviewed_at).to eq(Time.current)
      end

      it 'updates rejected_reason' do
        expect(contribution.rejected_reason).to eq(:other_reason)
      end
    end
  end

  describe 'scopes' do
    let!(:today_contribution) { create :contribution, :with_users, users_count: 1 }
    let!(:last_week_contribution) { create :contribution, :with_users, users_count: 1, created_at: 1.week.ago }
    let(:tracking_contribution) { create :contribution, tracking: true }

    it 'is in this week' do
      expect(described_class.this_week).to contain_exactly(today_contribution)
    end

    it 'is in last week' do
      expect(described_class.last_week).to contain_exactly(last_week_contribution)
    end

    it 'has active engineer' do
      create :contribution, users: [create(:user, :inactive)]

      expect(described_class.active_engineers).to contain_exactly(today_contribution, last_week_contribution)
    end

    it 'is tracking' do
      expect(described_class.tracking).to contain_exactly(tracking_contribution)
    end

    describe '.by_user' do
      let(:user) { create(:user) }
      let!(:user_contribution) { create(:contribution) }
      let!(:other_contribution) { create(:contribution) }

      context 'when user is present' do
        it 'returns only the user contributions' do
          user_contribution.users << user
          expect(described_class.by_user(user.id)).to contain_exactly(user_contribution)
        end
      end

      context 'when user is not present' do
        it 'returns all of the contributions' do
          expect(described_class.by_user(nil)).to include(user_contribution, other_contribution)
        end
      end
    end

    describe '.by_state' do
      let!(:received_contribution) { create(:contribution, :received) }
      let!(:approved_contribution) { create(:contribution, :approved) }

      context 'when state is present' do
        it 'returns only the contributions with the given state' do
          expect(described_class.by_state('approved')).to contain_exactly(approved_contribution)
        end
      end

      context 'when state is not present' do
        it 'returns all the contributins' do
          expect(described_class.by_state(nil)).to include(received_contribution, approved_contribution)
        end
      end
    end

    describe '.by_reviewed_at_from' do
      let!(:october_reviewed_contribution) { create(:contribution, reviewed_at: '2022-10-02') }
      let!(:november_reviewed_contribution) { create(:contribution, reviewed_at: '2022-11-02') }

      context 'when date is present' do
        it 'returns contributions reviewed from given date' do
          expect(described_class.by_reviewed_at_from('2022-11-01')).to eq([november_reviewed_contribution])
        end
      end

      context 'when date is not present' do
        it 'returns all the contributions' do
          expect(described_class.by_reviewed_at_from(nil)).to include(october_reviewed_contribution, november_reviewed_contribution)
        end
      end
    end

    describe 'by_reviewed_at_until' do
      let!(:october_reviewed_contribution) { create(:contribution, reviewed_at: '2022-10-02') }
      let!(:november_reviewed_contribution) { create(:contribution, reviewed_at: '2022-11-02') }

      context 'when date is present' do
        it 'returns contributions reviewed until given date' do
          expect(described_class.by_reviewed_at_until('2022-10-10')).to eq([october_reviewed_contribution])
        end
      end

      context 'when date is not present' do
        it 'returns all the contributions' do
          expect(described_class.by_reviewed_at_until(nil)).to include(october_reviewed_contribution, november_reviewed_contribution)
        end
      end
    end

    describe '.by_created_at_from' do
      let!(:october_created_contribution) { create(:contribution, created_at: '2022-10-02') }
      let!(:november_created_contribution) { create(:contribution, created_at: '2022-11-02') }

      context 'when date is present' do
        it 'returns contributions created from given date' do
          expect(Contribution.by_created_at_from('2022-11-01')).to include(november_created_contribution)
            .and not_include(october_created_contribution)
        end
      end

      context 'when date is not present' do
        it 'returns all the contributions' do
          expect(described_class.by_created_at_from(nil)).to include(october_created_contribution, november_created_contribution)
        end
      end
    end

    describe 'by_created_at_until' do
      let!(:october_created_contribution) { create(:contribution, created_at: '2022-10-02') }
      let!(:november_created_contribution) { create(:contribution, created_at: '2022-11-02') }

      context 'when date is present' do
        it 'returns contributions created until given date' do
          expect(Contribution.by_created_at_until('2022-10-10')).to eq([october_created_contribution])
        end
      end

      context 'when date is not present' do
        it 'returns all the contributions' do
          expect(described_class.by_created_at_until(nil)).to include(october_created_contribution, november_created_contribution)
        end
      end
    end
  end

  describe '.without_description' do
    let!(:contributions) { create_list :contribution, 2, description: }

    context 'when contribution has no description' do
      let(:description) { nil }

      it 'returns the contributions' do
        expect(described_class.without_description).to match_array(contributions)
      end
    end

    context 'when contribution have description' do
      let(:description) { "Described" }

      it 'returns empty relation' do
        expect(described_class.without_description).to be_empty
      end
    end
  end

  describe '.without_pr_state' do
    it "returns contributions without the received pr state" do
      open_pr = create :contribution, pr_state: :open
      create :contribution, pr_state: :merged

      expect(described_class.without_pr_state(:merged)).to contain_exactly(open_pr)
    end
  end

  describe 'validations' do
    context 'when the contribution is received' do
      context 'and rejected_reason is present' do
        let(:contribution) { build(:contribution, state: :received, rejected_reason: :wrong_understanding_of_issue) }

        it { expect(contribution).to be_invalid }

        it 'raises an error' do
          expect { contribution.save! }.to raise_error(ActiveRecord::RecordInvalid, 'A validação falhou: Motivo da recusa deve ficar em branco')
        end
      end

      context 'and rejected_reason is missing' do
        let(:contribution) { build(:contribution, state: :received, rejected_reason: nil) }

        it { expect(contribution).to be_valid }
      end
    end

    context 'when the contribution is approved' do
      context 'and rejected_reason is present' do
        let(:contribution) { build(:contribution, state: :approved, rejected_reason: :wrong_understanding_of_issue) }

        it { expect(contribution).to be_invalid }

        it 'raises an error' do
          expect { contribution.save! }.to raise_error(ActiveRecord::RecordInvalid, 'A validação falhou: Motivo da recusa deve ficar em branco')
        end
      end

      context 'and rejected_reason is missing' do
        let(:contribution) { build(:contribution, state: :approved, rejected_reason: nil) }

        it { expect(contribution).to be_valid }
      end
    end

    context 'when the contribution is refused' do
      context 'and rejected_reason is present' do
        let(:contribution) { build(:contribution, state: :refused, rejected_reason: :wrong_understanding_of_issue) }

        it { expect(contribution).to be_valid }
      end

      context 'and rejected_reason is missing' do
        let(:contribution) { build(:contribution, state: :refused, rejected_reason: nil) }

        it { expect(contribution).to be_invalid }

        it 'raises an error' do
          expect { contribution.save! }.to raise_error(ActiveRecord::RecordInvalid, 'A validação falhou: Motivo da recusa não pode ficar em branco')
        end
      end
    end
  end
end
