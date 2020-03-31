# frozen_string_literal: true

require 'rails_helper'
require 'aasm/rspec'

RSpec.describe Contribution, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:company) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :link }
    it { is_expected.to validate_presence_of :state }

    context 'after the contribution is created' do
      context 'without a valid repository' do
        subject(:contribution) { create :contribution }

        it 'has to transition to refused' do
          expect(contribution).to have_state(:refused)
        end
      end

      context 'with a valid repository' do
        subject(:contribution) { create :contribution, :with_valid_repository }

        it 'has to maintain received state' do
          expect(contribution).to have_state(:received)
        end
      end
    end
  end

  describe 'states' do
    subject(:contribution) { build :contribution }

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

    it 'is in this week' do
      expect(described_class.this_week.first).to eq(today_contribution)
    end

    it 'is in last week' do
      expect(described_class.last_week.first).to eq(last_week_contribution)
    end
  end
end