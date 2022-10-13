# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vacation, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:commercial_approver).class_name('User').optional }
    it { is_expected.to belong_to(:administrative_approver).class_name('User').optional }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:end_date) }
    it { is_expected.to validate_presence_of(:user) }

    context 'start_date greater than end_date' do
      let(:start_date) { 2.months.from_now }
      let(:end_date) { Date.current }
      let(:vacation) { build(:vacation, start_date: start_date, end_date: end_date) }

      it 'vacation is invalid' do
        expect(vacation).to_not be_valid
      end
    end

    context 'end_date greater than start_date' do
      let(:vacation) { build(:vacation) }

      it 'vacation is valid' do
        expect(vacation).to be_valid
      end
    end
  end
end
