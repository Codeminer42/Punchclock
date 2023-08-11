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
      let!(:repository) { create(:repository, language: nil).decorate }
      let(:github_languages_success) { true }
      let(:github_get_success) { true }
      let(:client) do
        class_double(
          'Github',
          repos: double(
            languages: double(
              success?: github_languages_success,
              body: { ruby: 'ruby' }
            ),
            get: double(
              success?: github_get_success,
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

      context 'when github languages API endpoint is not successful' do
        let(:github_languages_success) { false }

        it 'returns repositories languages as nil' do
          repository, = github_repositories_sync.call
          expect(repository.language).to be_nil
        end
      end

      context 'when github get API endpoint is not successful' do
        let(:github_get_success) { false }

        it 'returns repositories issues as nil' do
          repository, = github_repositories_sync.call
          expect(repository.issues).to be_nil
        end

        it 'returns repositories stars as nil' do
          repository, = github_repositories_sync.call
          expect(repository.stars).to be_nil
        end
      end
    end
  end
end
