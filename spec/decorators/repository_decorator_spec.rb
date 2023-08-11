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

  describe '#issues_formatted' do
    context 'when repository has less than 1_000 issues' do
      let(:repository) { build(:repository, issues: 999).decorate }

      it 'returns 999' do
        expect(repository.issues_formatted).to eql '999'
      end
    end

    context 'when repository has 1_000 issues' do
      let(:repository) { build(:repository, issues: 1_000).decorate }

      it 'returns 1K' do
        expect(repository.issues_formatted).to eql '1K'
      end
    end

    context 'when repository has more than 1_001 issues' do
      let(:repository) { build(:repository, issues: 1_001).decorate }

      it 'returns 1K' do
        expect(repository.issues_formatted).to eql '1K'
      end
    end

    context 'when repository has 1 million issues' do
      let(:repository) { build(:repository, issues: 1_000_000).decorate }

      it 'returns 1M' do
        expect(repository.issues_formatted).to eql '1M'
      end
    end

    context 'when repository has more than 1 million issues' do
      let(:repository) { build(:repository, issues: 1_000_001).decorate }

      it 'returns 1M' do
        expect(repository.issues_formatted).to eql '1M'
      end
    end

    context 'when repository has 0 issues' do
      let(:repository) { build(:repository, issues: 0).decorate }

      it 'returns 0' do
        expect(repository.issues_formatted).to eql '0'
      end
    end

    context 'when repository has no issues' do
      let(:repository) { build(:repository, issues: nil).decorate }

      it 'returns 0' do
        expect(repository.issues_formatted).to eql '0'
      end
    end
  end

  describe '#stars_formatted' do
    context 'when repository has less than 1_000 stars' do
      let(:repository) { build(:repository, stars: 999).decorate }

      it 'returns 999' do
        expect(repository.stars_formatted).to eql '999'
      end
    end

    context 'when repository has 1_000 stars' do
      let(:repository) { build(:repository, stars: 1_000).decorate }

      it 'returns 1K' do
        expect(repository.stars_formatted).to eql '1K'
      end
    end

    context 'when repository has more than 1_001 stars' do
      let(:repository) { build(:repository, stars: 1_001).decorate }

      it 'returns 1K' do
        expect(repository.stars_formatted).to eql '1K'
      end
    end

    context 'when repository has 1 million stars' do
      let(:repository) { build(:repository, stars: 1_000_000).decorate }

      it 'returns 1M' do
        expect(repository.stars_formatted).to eql '1M'
      end
    end

    context 'when repository has more than 1 million stars' do
      let(:repository) { build(:repository, stars: 1_000_001).decorate }

      it 'returns 1M' do
        expect(repository.stars_formatted).to eql '1M'
      end
    end

    context 'when repository has 0 stars' do
      let(:repository) { build(:repository, stars: 0).decorate }

      it 'returns 0' do
        expect(repository.stars_formatted).to eql '0'
      end
    end

    context 'when repository has no stars' do
      let(:repository) { build(:repository, stars: nil).decorate }

      it 'returns 0' do
        expect(repository.stars_formatted).to eql '0'
      end
    end
  end
end
