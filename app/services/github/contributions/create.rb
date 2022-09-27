# frozen_string_literal: true

module Github
  module Contributions
    class Create
      def initialize(client:)
        @client = client
      end

      def call
        Rails.logger.info("[GH] -- Contributions: #{collect_all_contributions.size}")

        collect_all_contributions
          .map do |result|
            find_or_create_contribution(
              result.user_id,
              result.repository_id,
              result.pull_request_url,
              result.created_at
            )
          end
      end

      private

      attr_reader :client

      def collect_all_contributions
        @collect_all_contributions ||=
          Collect.new(client: client).all
      end

      def find_or_create_contribution(uid, rid, link, created_at)
        Contribution.find_or_create_by(
          user_id: uid,
          repository_id: rid,
          link: link,
          created_at: created_at
        )
      end
    end
  end
end
