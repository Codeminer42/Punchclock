require 'rails_helper'

RSpec.describe Github::Contributions::Wrappers::Repositories, type: :service do
  describe '#empty?' do
    subject(:empty) { described_class.new.empty? }

    context 'when there are no repositories' do
      it { is_expected.to be true }
    end

    context 'when there are repositories' do
      let!(:repository) { create(:repository) }

      it { is_expected.to be false }
    end
  end

  describe '#to_query' do
    subject(:to_query) { described_class.new.to_query }

    context 'when there are no repositories' do
      it { is_expected.to be_empty }
    end

    context 'when there are repositories' do
      let!(:repository) { create(:repository) }

      it { is_expected.to eq("repo:#{repository.link.split('com/').last}") }
    end
  end

  describe '#find_repository_id_by_name' do
    subject(:find_repository_id_by_name) { described_class.new }

    context 'when the id is not found' do
      it 'returns nil' do
        expect(find_repository_id_by_name.find_repository_id_by_name('')).to be_nil
      end
    end
    
    context 'when the user is found' do
      let(:repository) { create(:repository) }
      let(:repository_to_find) { repository.link.split('com/').last }

      it 'returns repository id' do
        expect(find_repository_id_by_name.find_repository_id_by_name(repository_to_find)).to eq(repository.id)
      end
    end
  end
end
