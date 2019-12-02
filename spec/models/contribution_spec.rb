# frozen_string_literal: true

require 'rails_helper'
require 'aasm/rspec'

RSpec.describe Contribution, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:company) }
    it { is_expected.to have_many(:reviews).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :link }
    it { is_expected.to validate_presence_of :state }
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
end
