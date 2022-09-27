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
          repository_owner, repository_name = repository.link.split('/')[-2..-1]

          request = client.repos.languages(repository_owner, repository_name)

          if request.success?
            languages = request.body.keys[0..MAX_LANGUAGES_NUMBER-1].join(', ')

            repository.update(language: languages)
          end
        end.compact
      end

      private

      attr_reader :client

      def repositories
        @repositories ||= Repository.all
      end
    end
  end
end
