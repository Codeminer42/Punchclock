# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository, type: :model do
  it { is_expected.to have_many(:contributions).dependent(:nullify) }

  describe 'validations' do
    subject { build :repository }

    it { is_expected.to validate_presence_of(:link) }
    it { is_expected.to validate_uniqueness_of(:link).case_insensitive }
  end

  describe 'with_distinct_languages' do
    before do
      create_list(:repository, 2, language: 'Ruby')
      create_list(:repository, 2, language: 'Java')
      create(:repository, language: nil)
    end

    it 'returns a relation containing repositories with distinct languages without duplicates' do
      expect(described_class.with_distinct_languages.pluck(:language)).to contain_exactly('Ruby', 'Java')
    end
  end

  describe 'by_repository_name_like' do
    context 'when searching for a repository by its partial or total name' do
      before do
        create(:repository, language: 'Ruby', link: 'https://github.com/Codeminer42/Punchclock')
        create(:repository, language: 'Ruby', link: 'https://github.com/ruby/ruby')
      end

      subject { described_class.by_repository_name_like('punch') }

      it "returns repositories with a link that matches the search" do
        expect(subject.pluck(:link)).to eq(['https://github.com/Codeminer42/Punchclock'])
      end
    end

    context 'when searching for a repository by using nil' do
      let(:repositories_list) { create_list(:repository, 2) }

      subject { described_class.by_repository_name_like(nil) }

      it "returns all repositories" do
        expect(subject).to eq(repositories_list)
      end
    end
  end

  describe 'by_languages' do
    context 'when searching for repositories by its languages' do
      let(:link) { 'http://github.com/facebook/create-react-app' }
      before do
        create(:repository, language: 'Ruby')
        create(:repository, language: 'Javascript', link:)
      end

      subject { described_class.by_languages(['Javascript']) }

      it "returns repositories with a link that matches the search" do
        expect(subject.pluck(:link)).to eq([link])
      end
    end

    context 'when searching for a repository that does not have a language' do
      let(:repositories_list) { create_list(:repository, 2, language: 'Java') }

      subject { described_class.by_languages(nil) }

      it "returns all repositories" do
        expect(subject).to eq(repositories_list)
      end
    end
  end
end
