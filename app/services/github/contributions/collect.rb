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

          fetch_pull_requests(search_query: query)
        rescue StandardError => e
          Rails.logger.error e.message
          Rails.logger.error e.backtrace.join("\n")
          []
        end
      end

      def fetch_pull_requests(search_query:)
        client.search.issues(q: search_query).items.map do | pull_request |
          repository_name = pull_request.html_url.split("/")[-4..-3].join("/")
          user_id = @engineers.get_engineer_id_by_github_user(pull_request.user.login)
          repository_id = @repositories.get_repository_id_by_name(repository_name)

          Result.new(user_id, repository_id, pull_request.html_url, pull_request.created_at)
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
