require 'rails_helper'

RSpec.describe Github::Repository, type: :service do
  describe '.fetch_languages' do
    subject(:result) { described_class.fetch_languages(repository.link) } 

    context 'when the link is valid', vcr: true do
      let!(:repository) { build_stubbed(:repository, link: 'https://github.com/Codeminer42/cm42-central') }

      it 'returns all languages' do
        languages = 'JavaScript, Ruby, HTML, CSS, Dockerfile, CoffeeScript'
        expect(result.languages).to eq(languages)
      end
    end

    context 'when the link has an extra foward slash', vcr: true do
      let!(:repository) { build_stubbed(:repository, link: 'https://github.com/Codeminer42/docker-ci-ruby/') }

      it 'returns all languages' do
        expect(result.languages).to eq('Dockerfile')
      end
    end

    context 'when the link does not exists', vcr: true do
      let!(:repository) { build_stubbed(:repository, link: 'https://github.com/Codeminer42/project-test/') }

      it 'returns nil' do
        expect(result.success?).to be_falsey
      end
    end
  end
end
