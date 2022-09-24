require 'rails_helper'

RSpec.describe ContributionDecorator do

  describe '#reviewed_by_short_name' do
    subject { described_class.new(contribution).reviewed_by_short_name }

    let(:contribution) { build_stubbed(:contribution, reviewed_by: reviewed_by) }

    context 'when reviewed name has 3 names' do
      let(:reviewed_by) { build_stubbed(:user, name: 'A_Name1 B_Name2 C_Name3') }

      it { is_expected.to eq 'AC' }
    end

    context 'when reviewed name has names in downcase and upcase' do
      let(:reviewed_by) { build_stubbed(:user, name: 'A_Name1 b_Name2 c_Name3') }

      it { is_expected.to eq 'AC' }
    end

    context 'when reviewed name has 2 names' do
      let(:reviewed_by) { build_stubbed(:user, name: 'A_Name1 b_Name2') }

      it { is_expected.to eq 'AB' }
    end

    context 'when reviewed name has 1 name' do
      let(:reviewed_by) { build_stubbed(:user, name: 'A_Name1') }

      it { is_expected.to eq 'A' }
    end
  end

  describe '#created_at' do
    subject { described_class.new(contribution).created_at }

    let(:contribution) { build_stubbed(:contribution, created_at: DateTime.parse('2022-08-26T16:50')) }

    it { is_expected.to eq '26/08/2022' }
  end

  describe '#reviewed_at' do
    subject { described_class.new(contribution).reviewed_at }

    context 'when reviewed_at exists' do
      let(:contribution) { build_stubbed(:contribution, reviewed_at: DateTime.parse('2022-08-26T16:50')) }

      it { is_expected.to eq '26/08/2022' }
    end
  end
end
