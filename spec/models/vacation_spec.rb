# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vacation, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:hr_approver).class_name('User').optional }
    it { is_expected.to belong_to(:commercial_approver).class_name('User').optional }
    it { is_expected.to belong_to(:denier).class_name('User').optional }
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

  describe '#approve!' do
    subject(:vacation) { create(:vacation) }

    context 'when user is hr' do
      let(:user) { create(:user, :hr) }

      it 'set hr approver' do
        expect { subject.approve! user }.to change { vacation.hr_approver }.from(nil).to(user)
      end
    end

    context 'when user is a project manager' do
      let(:user) { create(:user, :commercial) }

      it 'set project manager approver' do
        expect { subject.approve! user }.to change { vacation.commercial_approver }.from(nil).to(user)
      end
    end

    context 'when both roles approve' do
      let(:hr_user) { create(:user, :hr) }
      let(:commercial_user) { create(:user, :commercial) }

      before do
        subject.approve! hr_user
        subject.approve! commercial_user
      end

      it 'set project manager approver' do
        expect(subject).to be_approved
      end
    end
  end

  describe '#deny!' do
    subject(:vacation) { create(:vacation) }
    let(:user) { create(:user, :hr) }

    it 'set project manager approver' do
      subject.deny! user

      expect(subject).to be_denied
    end
  end
end
