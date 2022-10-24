# frozen_string_literal: true

module Github
  module Contributions
    class Update
      def initialize(client:)
        @client = client
      end

      def call
        Rails.logger.info("[GH] -- Contributions: #{ongoing_contributions.size}")

        ongoing_contributions.map do |result|
          update(result[:id], result[:pr_state])
        end
      end

      private

      attr_reader :client

      def ongoing_contributions
        @ongoing_contributions ||=
          PullRequestCollector.new(client: client).all
      end

      def update(id, pr_state)
        Contribution.find(id).update(pr_state: pr_state)
      end
    end
  end
end
