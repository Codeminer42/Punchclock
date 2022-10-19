# frozen_string_literal: true

module Github
  module Contributions
    class PullRequestCollector
      ORG_INDEX = 3
      REPO_INDEX = 4
      PR_INDEX = 6

      def initialize(client:)
        @client = client
      end

      def all
        fetch_all
      end

      private

      attr_reader :client

      def fetch_all
        valid_pull_requests = Contribution.where.not(state: :refused).select(:id, :link, :pr_state)
        updated_pull_request = valid_pull_requests.map {|contribution| { id: contribution.id, pr_state: current_pr_state(contribution.link)} }

        updated_pull_request.select{ |el| el[:pr_state] != valid_pull_requests.find_by(id: el[:id]).pr_state }
      end

      def current_pr_state(link)
        pr_body = fetch_pr(link)

        return 'Merged' if pr_body.pull_request&.merged_at
        pr_body.state.capitalize
      end

      def fetch_pr(link)
        begin
          organization, repository, pr_id = parse_contribution_link(link)
          client.issues.get(organization, repository, pr_id).body

        rescue StandardError => e
          Rails.logger.error e.message
          Rails.logger.error e.backtrace.join("\n")
          []
        end
      end

      def parse_contribution_link(link)
        link.split("/").values_at(ORG_INDEX, REPO_INDEX, PR_INDEX)
      end
    end
  end
end
