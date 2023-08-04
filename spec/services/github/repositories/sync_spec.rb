# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Github::Repositories::Sync, type: :service do
  include EnvHelper

  around do |example|
    with_temp_env('GITHUB_OAUTH_TOKEN' => 'github-api-token', &example)
  end

  describe '#call' do
    subject(:github_repositories_sync) { described_class.new(client:) }

    let(:client) { instance_double('Github') }

    context 'when there are no repositories in database' do
      it 'is expected to be empty' do
        expect(github_repositories_sync.call).to be_empty
      end
    end

    context 'when there are repositories in database' do
      let!(:repository) { create(:repository).decorate }
      let(:client) do
        class_double(
          'Github',
          repos: double(
            languages: double(
              success?: true,
              body: { ruby: 'ruby' }
            ),
            get: double(
              success?: true,
              body: { 'open_issues_count' => 3, 'stargazers_count' => 4 }
            )
          )
        )
      end

      it 'returns updated repositories languages' do
        repository, = github_repositories_sync.call
        expect(repository.language).to eq('ruby')
      end

      it 'returns updated repositories issues' do
        repository, = github_repositories_sync.call
        expect(repository.issues).to eq(3)
      end

      it 'returns updated repositories stars' do
        repository, = github_repositories_sync.call
        expect(repository.stars).to eq(4)
      end
    end
  end
end
