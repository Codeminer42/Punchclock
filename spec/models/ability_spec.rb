# frozen_string_literal: true

require 'spec_helper'
require 'cancan/matchers'

describe 'User' do
  let(:user) { FactoryBot.build(:user, id: 1) }
  subject(:ability) { Ability.new(user) }

  describe 'abilities user' do
    context 'when is creating punches' do
      it { is_expected.not_to be_able_to(:manage, Punch.new) }
    end

    context 'when is trying to manage Projects' do
      it { is_expected.not_to be_able_to(:manage, Project.new) }
    end

    context 'when is trying to perform operations on Users' do
      it { is_expected.to be_able_to(:read, User.new(id: user.id)) }
      it { is_expected.not_to be_able_to(:read, User.new) }
      it { is_expected.to be_able_to(:edit, User.new(id: user.id)) }
      it { is_expected.not_to be_able_to(:edit, User.new) }
      it { is_expected.to be_able_to(:update, User.new(id: user.id)) }
      it { is_expected.not_to be_able_to(:update, User.new) }
    end
  end

  describe 'vacations abilities' do
    describe 'when status is pending' do
      context 'allows user to cancel a vacation' do
        it { is_expected.to be_able_to(:destroy, Vacation.new) }
      end
    end

    describe 'when status is approved' do
      let(:vacation) do
        create(:vacation, {
            status: :approved,
            start_date: Date.new(2022, 12, 27)
          }
        )
      end

      it 'does not allow the user to cancel a vacation less than 7 days ahead of time' do
        allow(Date).to receive(:today).and_return(Date.new(2022, 12, 21))

         is_expected.not_to be_able_to(:destroy, vacation)
      end

      it 'allows user the user to cancel a vacation more than 7 days ahead of time' do
        allow(Date).to receive(:today).and_return(Date.new(2022, 12, 20))

        is_expected.to be_able_to(:destroy, vacation)
      end
    end
  end
end
