# frozen_string_literal: true

require 'rails_helper'
require 'aasm/rspec'

RSpec.describe Contribution, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:repository) }
  it { is_expected.to belong_to(:reviewed_by).class_name('User').optional }
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
        contribution.approve(reviewer.id)
      end

      it 'has state approved' do
        expect(contribution).to have_state(:approved)
      end

      it 'updates reviewer_id' do
        expect(contribution.reviewer_id).to be(reviewer.id)
      end

      it 'updates reviewed_at' do
        expect(contribution.reviewed_at).to eq(Time.current)
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
    end
  end

  describe 'scopes' do
    let!(:today_contribution) { create :contribution }
    let!(:last_week_contribution) { create :contribution, created_at: 1.week.ago }

    it 'is in this week' do
      expect(described_class.this_week).to contain_exactly(today_contribution)
    end

    it 'is in last week' do
      expect(described_class.last_week).to contain_exactly(last_week_contribution)
    end

    it 'has active engineer' do
      create :contribution, user: create(:user, :inactive)

      expect(described_class.active_engineers).to contain_exactly(today_contribution, last_week_contribution)
    end

  end

  describe '.without_pr_state' do
    it "returns contributions without the received pr state" do
      open_pr = create :contribution, pr_state: :open
      create :contribution, pr_state: :merged

      expect(described_class.without_pr_state(:merged)).to contain_exactly(open_pr)
    end
  end
end
