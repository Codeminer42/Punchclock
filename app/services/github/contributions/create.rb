# frozen_string_literal: true

module Github
  module Contributions
    class Create
      def initialize(company:, client:)
        @company = company
        @client = client
      end

      def call
        return [] if company.blank?

        Rails.logger.info("[GH] -- Contributions: #{collect_all_contributions.size}")

        collect_all_contributions
          .map do |result|
            find_or_create_contribution(
              result.uid,
              result.rid,
              result.pull_request._links.html.href,
              result.pull_request.created_at
            )
          end
      end

      private

      attr_reader :company, :client

      def collect_all_contributions
        @collect_all_contributions ||=
          Collect.new(company: company, client: client).all
      end

      def find_or_create_contribution(uid, rid, link, created_at)
        Contribution.find_or_create_by(
          user_id: uid,
          repository_id: rid,
          link: link,
          company: company,
          created_at: created_at
        )
      end
    end
  end
end
