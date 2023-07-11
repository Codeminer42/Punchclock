# frozen_string_literal: true

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

  describe '#repository_name' do
    context 'when there iss no repository' do
      subject(:without_repository) { build(:contribution, :without_repository).decorate }

      it 'is expected to return nil' do
        expect(without_repository.repository_name).to be_nil
      end
    end

    context 'when there is a repository' do
      subject(:contribution) { build(:contribution, :with_custom_repository).decorate }

      it 'is expected to return the repository name' do
        expect(contribution.repository_name).to eq('repo')
      end
    end
  end

  describe '#description' do
    subject { described_class.new(contribution).description }

    context 'when description is nil' do
      let(:contribution) { build_stubbed(:contribution, description: nil) }

      it { is_expected.to eq 'pending description' }
    end

    context 'when description is not nil' do
      let(:contribution) { build_stubbed(:contribution, description: 'Contribution description') }

      it { is_expected.to eq 'Contribution description' }
    end
  end
end
