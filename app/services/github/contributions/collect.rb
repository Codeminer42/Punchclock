# frozen_string_literal: true

module Github
  module Contributions
    class Collect
      Result = Struct.new(:uid, :rid, :pull_request_url, :created_at)

      def initialize(company:, client:)
        @company = company
        @client = client
        @engineers = Wrappers::Engineers.new(company: company)
        @repositories = Wrappers::Repositories.new(company: company)
      end

      def all
        return [] if company.blank? || insufficient_parameters_to_query?
        fetch_all
      end

      private

      attr_reader :company, :client

      def insufficient_parameters_to_query?
        @repositories.empty? || @engineers.empty?
      end

      def fetch_all
        begin
          query = QueryBuilder.build_query_string(
            authors_query,
            repositories_query
          )

          client.search
                .issues(q: query)
                .items
                .map { | pull_request | Wrappers::PullRequest.new(pull_request: pull_request, engineers: @engineers, repositories: @repositories) }
        rescue StandardError => e
          Rails.logger.error e.message
          Rails.logger.error e.backtrace.join("\n")
          []
        end
      end

      def repositories_query
        @repositories.to_query
      end

      def authors_query
        @engineers.to_query
      end
    end
  end
end
