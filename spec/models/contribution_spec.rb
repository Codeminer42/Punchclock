# frozen_string_literal: true

require 'rails_helper'
require 'aasm/rspec'

RSpec.describe Contribution, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:company) }
  it { is_expected.to belong_to(:repository) }
  it { is_expected.to validate_presence_of :link }
  it { is_expected.to validate_presence_of :state }

  describe 'defaults' do
    context 'after the contribution is created' do
      subject(:contribution) { create(:contribution) }

      it 'has received state' do
        expect(contribution).to have_state(:received)
      end
    end
  end

  describe 'states' do
    subject(:contribution) { build(:contribution) }

    context 'when the contribution is created' do
      it 'has state received' do
        expect(contribution).to have_state(:received)
      end

      it 'can transition to approved' do
        expect(contribution).to transition_from(:received).to(:approved).on_event(:approve)
      end

      it 'can transition to refused' do
        expect(contribution).to transition_from(:received).to(:refused).on_event(:refuse)
      end
    end

    context 'when the contribution is approved' do
      before { contribution.approve }

      it 'has state approved' do
        expect(contribution).to have_state(:approved)
      end
    end

    context 'when the contribution is refused' do
      before { contribution.refuse }

      it 'has state refused' do
        expect(contribution).to have_state(:refused)
      end
    end
  end

  describe 'scopes' do
    let!(:today_contribution) { create :contribution }
    let!(:last_week_contribution) { create :contribution, created_at: 1.week.ago }
    let!(:inactive_user_contribution) { create :contribution, user: create(:user, :inactive) }

    it 'is in this week' do
      expect(described_class.this_week.first).to eq(today_contribution)
    end

    it 'is in last week' do
      expect(described_class.last_week.first).to eq(last_week_contribution)
    end

    it 'has active engineer' do
      expect(described_class.active_engineers).to include(today_contribution, last_week_contribution)
      expect(described_class.active_engineers).not_to include inactive_user_contribution
    end
  end
end
