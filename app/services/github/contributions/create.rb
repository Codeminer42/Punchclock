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
          .map { |result| [result.uid, result.pull_request._links.html.href] }
          .map { |uid, link| Contribution.find_or_create_by(user_id: uid, link: link, company: company) }
      end

      private

      attr_reader :company, :client

      def collect_all_contributions
        @collect_all_contributions ||=
          Collect.new(company: company, client: client).all
      end
    end
  end
end
