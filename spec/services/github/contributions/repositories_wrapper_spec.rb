require 'rails_helper'

RSpec.describe Github::Contributions::RepositoriesWrapper, type: :service do

  let(:company) { build_stubbed(:company) }

  before do
    allow(company).to receive(:repositories).and_return(repositories)
  end

  describe '#repositories' do
    subject(:to_query) { described_class.new(company: company).repositories }

    context 'when there are no repositories' do
      let(:repositories) { double(pluck: []) }

      it { is_expected.to be_empty }
    end

    context 'when there are repositories' do
      let(:repositories) { double(pluck: [[1, 'https://github.com/owner1/name1'], [2, 'https://github.com/owner2/name2']]) }

      it { is_expected.to eq [['owner1', 'name1', 1], ['owner2', 'name2', 2]] }
    end
  end

  describe '#to_query' do
    subject(:to_query) { described_class.new(company: company).to_query }

    context 'when there are no repositories' do
      let(:repositories) { double(pluck: []) }

      it { is_expected.to be_empty }
    end

    context 'when there are repositories' do
      let(:repositories) { double(pluck: [[1, 'https://github.com/owner1/name1'], [2, 'https://github.com/owner2/name2']]) }

      it { is_expected.to eq 'repo:owner1/name1 repo:owner2/name2'}
    end
  end

  describe '#get_repository_id_by_name' do
    subject(:get_repository_id_by_name) { described_class.new(company: company).get_repository_id_by_name(repository_to_find) }
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
