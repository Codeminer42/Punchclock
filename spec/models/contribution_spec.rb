# frozen_string_literal: true

require 'rails_helper'
require 'aasm/rspec'

RSpec.describe Contribution, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:office) }
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

      context 'and contribution is approved' do
        before { contribution.approve }

        it 'has state approved' do
          expect(contribution).to have_state(:approved)
        end

        it 'can transition to closed' do
          expect(contribution).to transition_from(:approved).to(:closed).on_event(:close)
        end

        context 'and contribution is closed' do
          before { contribution.close }

          it 'has state approved' do
            expect(contribution).to have_state(:closed)
          end
        end
      end

      context 'and contribution is refused' do
        before { contribution.refuse }

        it 'has state refused' do
          expect(contribution).to have_state(:refused)
        end

        it 'can transition to contest' do
          expect(contribution).to transition_from(:refused).to(:contested).on_event(:contest)
        end

        context 'and contribution is contest' do
          before { contribution.contest }

          it 'has state contested' do
            expect(contribution).to have_state(:contested)
          end

          it 'can transition to approved' do
            expect(contribution).to transition_from(:contested).to(:approved).on_event(:approve)
          end

          it 'can transition to closed' do
            expect(contribution).to transition_from(:contested).to(:refused).on_event(:refuse)
          end
        end
      end
    end
  end
end
