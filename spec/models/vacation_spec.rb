# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vacation, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:commercial_approver).class_name('User').optional }
    it { is_expected.to belong_to(:administrative_approver).class_name('User').optional }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:end_date) }
    it { is_expected.to validate_presence_of(:user) }

    context 'when end_date is greater than start_date' do
      let(:start_date) { 1.months.from_now }
      let(:end_date) { 2.months.from_now }
      let(:vacation) { build(:vacation, start_date: start_date, end_date: end_date) }

      it 'vacation is valid' do
        expect(vacation).to be_valid
      end
    end

    context 'when start_date is greater than end_date' do
      let(:start_date) { 2.months.from_now }
      let(:end_date) { 1.months.from_now }
      let(:vacation) { build(:vacation, start_date: start_date, end_date: end_date) }

      it 'vacation is invalid' do
        expect(vacation).to_not be_valid
      end
    end

    context 'when end_date and start_date are the same' do
      let(:start_date) { 1.day.ago }
      let(:end_date) { 1.day.ago }
      let(:vacation) { build(:vacation, start_date: start_date, end_date: end_date) }

      it 'vacation is invalid' do
        expect(vacation).to_not be_valid
      end
    end

    context 'when start_date is today' do
      let(:start_date) { Date.current }
      let(:vacation) { build(:vacation, start_date: start_date) }

      it 'vacation is invalid' do
        expect(vacation).to_not be_valid
      end
    end

    context 'when start_date is in the past' do
      let(:start_date) { 1.day.ago }
      let(:vacation) { build(:vacation, start_date: start_date) }

      it 'vacation is invalid' do
        expect(vacation).to_not be_valid
      end
    end
  end

  describe '#set_approver' do
    subject { vacation.set_approver(user) }
    let(:vacation) { create(:vacation) }

    context 'when user is admin' do
      let(:user) { create(:user, :admin) }

      it 'set administrative approver' do
        expect { subject }.to change { vacation.administrative_approver }.from(nil).to(user)
      end
    end

    context 'when user is admin' do
      let(:user) { create(:user, :commercial) }

      it 'set commercial approver' do
        expect { subject }.to change { vacation.commercial_approver }.from(nil).to(user)
      end
    end
  end
end
