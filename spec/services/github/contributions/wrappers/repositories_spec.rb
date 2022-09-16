require 'rails_helper'

RSpec.describe Github::Contributions::Wrappers::Repositories, type: :service do
  describe '#empty?' do
    subject(:empty) { described_class.new.empty? }

    context 'when there are no repositories' do
      let(:repositories) { double(pluck: []) }

      it { is_expected.to be true }
    end

    context 'when there are repositories' do
      let(:repositories) { double(pluck: [[1, 'https://github.com/owner1/name1'], [2, 'https://github.com/owner2/name2']]) }

      it { is_expected.to be false }
    end
  end

  describe '#to_query' do
    subject(:to_query) { described_class.new.to_query }

    context 'when there are no repositories' do
      let(:repositories) { double(pluck: []) }

      it { is_expected.to be_empty }
    end

    context 'when there are repositories' do
      let(:repositories) { double(pluck: [[1, 'https://github.com/owner1/name1'], [2, 'https://github.com/owner2/name2']]) }

      it { is_expected.to eq 'repo:owner1/name1 repo:owner2/name2'}
    end
  end

  describe '#find_repository_id_by_name' do
    subject(:find_repository_id_by_name) { described_class.new.find_repository_id_by_name(repository_to_find) }
    let(:repository_to_find) { 'owner3/name3' }

    context 'when the id is not found' do
      let(:repositories) { double(pluck: [[1, 'https://github.com/owner1/name1'], [2, 'https://github.com/owner2/name2']]) }

      it { is_expected.to be_nil }
    end

    context 'when the user is found' do
      let(:repositories) { double(pluck: [[100, 'https://github.com/owner3/name3'], [2, 'https://github.com/owner2/name2']]) }

      it { is_expected.to eq 100  }
    end
  end
end
