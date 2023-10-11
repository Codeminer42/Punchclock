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
              result.created_at,
              result.pr_state,
              result.contributors_ids
            )
          end

        collect_all_contributions.map(&:user_id).uniq
                                 .map do |user_id|
          AlertFillContributionDescriptionJob.perform_later(user_id)
        end
      end

      private

      attr_reader :client

      def collect_all_contributions
        @collect_all_contributions ||=
          Collect.new(client:).all
      end

      def find_or_create_contribution(uid, rid, link, created_at, pr_state, contributors)
        contribution = Contribution.find_or_create_by(
          user_id: uid,
          repository_id: rid,
          link:,
          created_at:,
          pr_state:
        )

        contributors.each do |contributor_id|
          associate_users_with_contribution(contributor_id, contribution.id)
        end

        contribution
      end

      def associate_users_with_contribution(user_id, contribution_id)
        ContributionsUser.create(user_id: , contribution_id:)
      end
    end
  end
end
