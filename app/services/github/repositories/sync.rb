# frozen_string_literal: true

module Github
  module Repositories
    class Sync
      MAX_LANGUAGES_NUMBER = 6

      def initialize(client:)
        @client = client
      end

      def call
        Rails.logger.info("[GH] -- Repositories: #{repositories.count}")

        repositories.map do |repository|
          languages = fetch_repository_languages(repository.link)
          stats = fetch_repository_stats(repository.link)

          repository.update!(
            **(languages.present? ? { language: languages } : {}),
            **(stats.values.any? ? stats : {})
          )

          repository
        end.compact
      end

      private

      attr_reader :client

      def repositories
        @repositories ||= Repository.all
      end

      def fetch_repository_languages(repository_link)
        repository_owner, repository_name = repository_owner_and_name(repository_link)
        request = client.repos.languages(repository_owner, repository_name)

        return nil unless request.success?

        request.body.keys[0..MAX_LANGUAGES_NUMBER - 1].join(', ')
      end

      def fetch_repository_stats(repository_link)
        repository_owner, repository_name = repository_owner_and_name(repository_link)
        request = client.repos.get(repository_owner, repository_name)

        return {} unless request.success?

        {
          issues: request.body['open_issues_count'],
          stars: request.body['stargazers_count']
        }
      end

      def repository_owner_and_name(repository_link)
        repository_link.split('/')[-2..]
      end
    end
  end
end
