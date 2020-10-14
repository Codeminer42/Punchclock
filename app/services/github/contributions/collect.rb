# frozen_string_literal: true

module Github
  module Contributions
    class Collect
      Result = Struct.new(:uid, :pull_request)

      def initialize(company:, client:)
        @company = company
        @client = client
      end

      def all
        return [] if company.blank?

        repositories.flat_map do |repository_owner, repository_name|
          client.pull_requests
                .list(repository_owner, repository_name)
                .map do |pull_request|
                  uuid, = engineers.select { |_, username| username ==  pull_request.user.login }
                                   .flatten

                  Result.new(uuid, pull_request) if uuid.present?
                end.compact
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
                                 .pluck(:link)
                                 .map { |url| url.split('/')[-2..-1] }
                                 .compact
      end
    end
  end
end
