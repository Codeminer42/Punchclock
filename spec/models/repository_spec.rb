# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository, type: :model do
  it { is_expected.to have_many(:contributions).dependent(:nullify) }

  describe 'validations' do
    subject { build :repository }

    it { is_expected.to validate_presence_of(:link) }
    it { is_expected.to validate_uniqueness_of(:link).case_insensitive }
  end

  describe '#name' do
    subject(:repository) { build(:repository, link: "https://github.com/org/repo") }

    context 'when the link attribute is present' do
      it 'is expected to return the name correctly' do
        expect(repository.name).to eq('repo')
      end
    end
  end
end
