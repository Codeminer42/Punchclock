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
          update_repository_languages(repository)
          update_repository_stats(repository)

          repository
        end.compact
      end

      private

      attr_reader :client

      def repositories
        @repositories ||= Repository.all
      end

      def repository_owner_and_name(repository)
        repository.link.split('/')[-2..-1]
      end

      def update_repository_languages(repository)
        repository_owner, repository_name = repository_owner_and_name(repository)
        request = client.repos.languages(repository_owner, repository_name)

        if request.success?
          languages = request.body.keys[0..MAX_LANGUAGES_NUMBER-1].join(', ')

          repository.update(language: languages)
        end
      end

      def update_repository_stats(repository)
        repository_owner, repository_name = repository_owner_and_name(repository)
        request = client.repos.get(repository_owner, repository_name)

        if request.success?
          repository.update(
            issues: request.body['open_issues_count'],
            stars: request.body['stargazers_count']
          )
        end
      end
    end
  end
end
