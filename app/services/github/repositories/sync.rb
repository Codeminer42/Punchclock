# frozen_string_literal: true

module Github
  module Repositories
    class Sync
      def initialize(company:, client:)
        @company = company
        @client = client
      end

      def call
        return [] if company.blank?

        Rails.logger.info("[GH] -- Repositories: #{repositories.count}")

        repositories.map do |repository|
          repository_owner, repository_name = repository.link.split('/')[-2..-1]

          request = client.repos.languages(repository_owner, repository_name)

          if request.success?
            languages = request.body.keys.join(', ')

            repository.update(language: languages)
          end
        end.compact
      end

      private

      attr_reader :company, :client

      def repositories
        @repositories ||= company.repositories
      end
    end
  end
end
