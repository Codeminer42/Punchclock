# frozen_string_literal: true

module Github
  module Contributions
    class PullRequestCollector
      LINK_INDEX = { org: 3, repo: 4, pr: 6 }.freeze

      PR_STATE = {
        merged: 'merged',
        open: 'open',
        closed: 'closed',
        error: 'Fetch Error'
      }.freeze

      def initialize(client:)
        @client = client
      end

      def all
        valid_pull_requests = Contribution
          .valid_pull_requests
          .without_pr_state(:merged)
          .without_pr_state(:closed)
          .select(:id, :link, :pr_state)

        updated_pull_request = valid_pull_requests.lazy.map do |contribution| 
          { id: contribution.id, pr_state: fetch_pr_state(contribution.link)}
        end

        updated_pull_request.select { |new_pr| validate_update(valid_pull_requests.find(new_pr[:id]), new_pr) }.to_a
      end

      private

      attr_reader :client

      def validate_update(current_pr, new_pr)
        new_pr[:pr_state] != PR_STATE[:error] && current_pr.pr_state != new_pr[:pr_state]
      end

      def fetch_pr_state(link)
        pr_body = fetch_pr(link)

        return PR_STATE[:merged] if pr_body.pull_request&.merged_at
        PR_STATE[pr_body.state.to_sym]
      rescue Github::Error::GithubError => e
        Rails.logger.error e.message
        Rails.logger.error e.backtrace.join("\n")
        return PR_STATE[:error]
      end

      def fetch_pr(link)
        organization, repository, pr_id = parse_contribution_link(link)
        client.issues.get(organization, repository, pr_id).body
      end

      def parse_contribution_link(link)
        link.split("/").values_at(LINK_INDEX[:org], LINK_INDEX[:repo], LINK_INDEX[:pr])
      end
    end
  end
end
