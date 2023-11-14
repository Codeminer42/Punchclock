require 'rails_helper'

RSpec.describe Github::Contributions::Wrappers::Engineers, type: :service do

  describe '#empty?' do
    subject(:empty) { described_class.new.empty? }
    
    context 'when there are no engineers' do
      it { is_expected.to be true }
    end
    
    context 'when there are engineers' do
      let!(:user) { create(:user) }

      it { is_expected.to be false }
    end
  end

  describe '#to_query' do
    subject(:to_query) { described_class.new.to_query }

    context 'when there are no engineers' do
      it { is_expected.to be_empty }
    end

    context 'when there are engineers' do
      let!(:user) { create(:user) }

      it { is_expected.to eq "author:#{user.github}" }
    end
  end

  describe '#find_by_github_user' do
    subject(:find_by_github_user) { described_class.new.find_by_github_user(user.github) }
    let(:user) { create(:user) }
    
    context 'when the id is not found' do
      before do
        allow(user).to receive(:github).and_return('')
      end

      it { is_expected.to be_nil }
    end

    context 'when the user is found' do
      it { is_expected.to eq user  }
    end
  end

  describe '#find_by_email' do
    subject(:find_by_github_user) { described_class.new.find_by_email(user.email) }
    let(:user) { create(:user) }
    
    context 'when the user is not found' do
      before do
        allow(user).to receive(:email).and_return('')
      end

      it { is_expected.to be_nil }
    end

    context 'when the user is found' do
      it { is_expected.to eq user  }
    end
  end
end
