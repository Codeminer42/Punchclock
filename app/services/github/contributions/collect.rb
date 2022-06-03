# frozen_string_literal: true

module Github
  module Contributions
    class Collect
      Result = Struct.new(:uid, :rid, :pull_request)

      def initialize(company:, client:)
        @company = company
        @client = client
      end

      def all
        return [] if company.blank?

        yesterday_date = 1.day.ago.strftime("%Y-%m-%d") # YYYY-MM-DD

        repository_query = repositories.map do |repository_id, repository_owner, repository_name|
          "repo:#{repository_owner}/#{repository_name}"
        end.join(' ')

        author_query = engineers.map do |user_id, github_user|
          "author:#{github_user}"
        end.join(' ')

        query = "created:#{yesterday_date} is:pr #{author_query} #{repository_query}"

        client.search.issues(q: query).items.map do | pull_request |
          # TODO: Find a way to get both user_id and repository_id
          Result.new(user_id, repository_id, pull_request)
        end
      end

      private

      attr_reader :company, :client

      def engineers
        @engineers ||= company.users
                              .engineer
                              .active
                              .pluck(:id, :github)
      end

      def repositories
        @repositories ||= company.repositories
                                 .pluck(:id, :link)
                                 .map { |id, url| [id, url.split('/')[-2..-1]].flatten }
                                 .compact
      end
    end
  end
end
