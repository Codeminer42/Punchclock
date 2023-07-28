# frozen_string_literal: true

RSpec.describe RepositoryDecorator do
  describe '#languages' do
    context 'when repository has more than three languages' do
      let(:repository) { create(:repository, language: 'Javascript, Docker, Ruby, HTML, CSS').decorate }

      it 'returns only the first three' do
        expect(repository.languages).to eq(['Javascript', 'Docker',  'Ruby'])
      end
    end

    context 'when repository has less than three languages' do
      let(:repository) { create(:repository, language: 'Javascript, Docker').decorate }

      it 'returns available languages' do
        expect(repository.languages).to eq(['Javascript',  'Docker'])
      end
    end

    context 'when repository has no languages' do
      let(:repository) { create(:repository, language: nil).decorate }

      it 'returns empty string' do
        expect(repository.languages).to be_empty
      end
    end
  end

  describe '#name' do
    let(:repository) { build(:repository, link: "https://github.com/Codeminer42/rails2-r_ruby").decorate }

    it 'returns the repository name' do
      expect(repository.name).to eql "rails2-r_ruby"
    end
  end
end

