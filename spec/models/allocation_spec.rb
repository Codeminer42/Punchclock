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
    let(:allocation) { build_stubbed(:allocation, end_at: end_at) }

    context 'when end_at is nil' do
      let(:end_at) { nil }

      subject { allocation.days_until_finish }

      it { is_expected.to be_nil }
    end

    context 'when end_at is not nil' do
      let(:end_at) { Date.current.next_month }

      subject { allocation.days_until_finish }

      it { is_expected.to eq(end_at - Date.current)  }
    end
  end
end
