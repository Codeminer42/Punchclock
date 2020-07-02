require 'rails_helper'

RSpec.describe UpdateRepositoryLanguageService do
  describe '#perform' do
    subject(:perform) { described_class.new.perform }

    context 'with a repository with a language' do
      let!(:repo_with_language) { create(:repository) }

      before do
        allow(Github::Repository).to receive(:fetch_languages)
      end

      it 'does not update the repository language' do
        expect { perform }.not_to change(repo_with_language.reload, :language)
      end

      it 'does not call github repository service' do
        perform
        expect(Github::Repository).not_to have_received(:fetch_languages)
      end
    end

    context 'with a repository without language' do
      let!(:repo_without_language) { create(:repository, language: nil, link: 'https://github.com/Codeminer42/cm42-central') }
      let(:languages) { ['JavaScript', 'Ruby', 'HTML', 'CSS', 'Dockerfile', 'CoffeeScript'] }

      before do
        allow(Github::Repository)
          .to receive(:fetch_languages)
          .and_return(Github::Repository::Result.new(true, languages))
        perform
        repo_without_language.reload
      end

      it 'update with the correct languages' do
        expect(repo_without_language.language).to eq('JavaScript, Ruby, HTML, CSS, Dockerfile, CoffeeScript')
      end
    end

    context 'when the link is invalid' do
      let!(:repo_without_language) { create(:repository, language: nil) }

      before do
        allow(Github::Repository)
          .to receive(:fetch_languages)
          .and_return(Github::Repository::Result.new(false, []))
        perform
      end

      it 'does not change the repository language' do
        expect { repo_without_language.reload }.not_to change(repo_without_language, :language)
      end
    end
  end
end
