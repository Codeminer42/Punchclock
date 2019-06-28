# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Allocation, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:project) }
  end

  describe 'Delegate' do
    it { is_expected.to delegate_method(:office_name).to(:user) }
  end

  describe '#days_until_finish' do
    context 'when end_at is nil' do
      subject { build_stubbed(:allocation, end_at: nil) }

      it 'returns nil' do
        expect(subject.days_until_finish).to be_nil
      end
    end

    context 'when end_at is not nil' do
      subject { build_stubbed(:allocation, end_at: Date.current.next_month) }

      it 'returns how many days left' do
        expect(subject.days_until_finish).to eq(subject.end_at - Date.current)
      end
    end

    context 'when its already finished' do
      subject { build_stubbed(:allocation, end_at: Date.current - 1.month) }

      it 'returns finished' do
        expect(subject.days_until_finish).to eq('Finalizado')
      end
    end
  end
end
