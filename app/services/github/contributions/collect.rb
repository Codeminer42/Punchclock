# frozen_string_literal: true

module Github
  module Contributions
    class Collect
      Result = Struct.new(:uid, :rid, :pull_request_url, :created_at)

      def initialize(company:, client:)
        @company = company
        @client = client
      end

      def all
        return [] if company.blank? or not repositories_wrapper.has_repositories? or not engineers_wrapper.has_engineers?
        fetch_all
      end

      private

      attr_reader :company, :client

      def fetch_all
        begin
          yesterday_date = 1.day.ago.strftime("%Y-%m-%d")
          query = "created:#{yesterday_date} is:pr #{authors_query} #{repositories_query}"
          fetch_pull_requests(search_query: query)
        rescue => e
          Rails.logger.error e.message
          Rails.logger.error e.backtrace.join("\n")
          []
        end
      end

      def fetch_pull_requests(search_query:)
        client.search.issues(q: search_query).items.map do | pull_request |
          repository_name = pull_request.html_url.split("/")[-4..-3].join("/")
          user_id = engineers_wrapper.get_engineer_id_by_github_user(pull_request.user.login)
          repository_id = repositories_wrapper.get_repository_id_by_name(repository_name)

          Result.new(user_id, repository_id, pull_request.html_url, pull_request.created_at)
        end
      end

      def engineers_wrapper
        @engineers_wrapper ||= EngineersWrapper.new(company: company)
      end

      def repositories_wrapper
        @repositories_wrapper ||= RepositoriesWrapper.new(company: company)
      end

      def repositories_query
        repositories_wrapper.to_query
      end

      def authors_query
        engineers_wrapper.to_query
      end
    end
  end
end
