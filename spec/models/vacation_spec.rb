# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vacation, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:hr_approver).class_name('User').optional }
    it { is_expected.to belong_to(:commercial_approver).class_name('User').optional }
    it { is_expected.to belong_to(:denier).class_name('User').optional }
  end

  describe ".ongoing_and_scheduled" do
    let(:ongoing_vacation) { create(:vacation, :ongoing) }
    let(:scheduled_vacation) { create(:vacation, :scheduled) }

    before do
      create(:vacation, :pending)
      create(:vacation, :cancelled)
      create(:vacation, :denied)
      create(:vacation, :ended)
    end

    it "return only approved ongoing and scheduled vacations" do
      expect(described_class.ongoing_and_scheduled).to eq([ongoing_vacation, scheduled_vacation])
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:end_date) }
    it { is_expected.to validate_presence_of(:user) }

    context 'when end_date is greater than start_date' do
      subject(:vacation) do
        build(:vacation, start_date: 1.months.from_now, end_date: 2.months.from_now)
      end

      it { is_expected.to be_valid }
    end

    context 'when start_date is greater than end_date' do
      subject(:vacation) do
        build(:vacation, start_date: 2.months.from_now, end_date: 1.months.from_now)
      end

      it { is_expected.to_not be_valid }
    end

    context 'when end_date is greater than start_date but difference is less than 5 days' do
      subject(:vacation) do
        build(:vacation, start_date: 2.days.from_now, end_date: 3.days.from_now)
      end

      it { is_expected.to_not be_valid }
    end

    context 'when end_date and start_date are the same' do
      subject(:vacation) { build(:vacation, start_date: 1.day.ago, end_date: 1.day.ago) }

      it { is_expected.to_not be_valid }
    end

    context 'when start_date is today' do
      let(:vacation) { build(:vacation, start_date: Date.current) }

      it { expect(vacation).to_not be_valid }
    end

    context 'when start_date is in the past' do
      let(:vacation) { build(:vacation, start_date: 1.day.ago) }

      it { expect(vacation).to_not be_valid }
    end

    context 'when the duration of the vacation is less than 10 days' do
      let(:vacation) {build(:vacation, start_date: 1.day.from_now, end_date: 2.days.from_now)}

      it { expect(vacation).to_not be_valid }
    end

    context 'when the duration of the vacation is equal to 9 days' do
      let(:vacation) {build(:vacation, start_date: 1.day.from_now, end_date: 9.days.from_now)}

      it { expect(vacation).to_not be_valid }
    end

    context 'when the duration of the vacation is equal to 10 days' do
      let(:vacation) {build(:vacation, start_date: 1.day.from_now, end_date: 10.days.from_now)}

      it { expect(vacation).to be_valid }
    end

    context 'when the duration of the vacation is higher than 10 days' do
      let (:vacation) {build(:vacation, start_date: 1.day.from_now, end_date: 20.days.from_now)}

      it { expect(vacation).to be_valid }
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

  describe '#duration_days' do
    subject(:vacation) { create(:vacation, start_date: 10.days.from_now, end_date: 30.days.from_now) }

    it 'returns the duration of the vacation in days' do
      expect(subject.duration_days).to eq(21)
    end
  end
end
