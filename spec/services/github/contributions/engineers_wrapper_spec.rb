require 'rails_helper'

RSpec.describe Github::Contributions::EngineersWrapper, type: :service do

  let(:company) { build_stubbed(:company) }
  let(:engineers) { double(active: active_engineers) }
  let(:users) { double(engineer: engineers) }

  before do
    allow(company).to receive(:users).and_return(users)
  end

  describe '#has_engineers' do
    subject(:has_engineers) { described_class.new(company: company).has_engineers? }

    context 'when there are no engineers' do
      let(:active_engineers) { double(pluck: []) }

      it { is_expected.to be false }
    end

    context 'when there are engineers' do
      let(:active_engineers) { double(pluck: [['user1', 1], ['user2', 2]]) }

      it { is_expected.to be true }
    end
  end

  describe '#to_query' do
    subject(:to_query) { described_class.new(company: company).to_query }

    context 'when there are no engineers' do
      let(:active_engineers) { double(pluck: []) }

      it { is_expected.to be_empty }
    end

    context 'when there are engineers' do
      let(:active_engineers) { double(pluck: [['user1', 1], ['user2', 2]]) }

      it { is_expected.to eq 'author:user1 author:user2'}
    end
  end

  describe '#get_engineer_id_by_github_user' do
    subject(:get_engineer_id_by_github_user) { described_class.new(company: company).get_engineer_id_by_github_user(github_user_to_find) }
    let(:github_user_to_find) { 'the_wanted_user' }

    context 'when the id is not found' do
      let(:active_engineers) { double(pluck: [['user1', 1], ['user2', 2]]) }

      it { is_expected.to be_nil }
    end

    context 'when the user is found' do
      let(:active_engineers) { double(pluck: [['the_wanted_user', 100], ['user1', 1], ['user2', 103]]) }

      it { is_expected.to eq 100  }
    end
  end
end
