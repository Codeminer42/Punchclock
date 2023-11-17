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
              result.repository_id,
              result.pull_request_url,
              result.created_at,
              result.pr_state,
              result.contributors
            )
          end

        collect_all_contributions.map(&:contributors).flatten.uniq
                                 .map do |contributor|
          AlertFillContributionDescriptionJob.perform_later(contributor.id)
        end
      end
      
      private

      attr_reader :client

      def collect_all_contributions
        @collect_all_contributions ||=
        Collect.new(client:).all
      end
      
      def find_or_create_contribution(rid, link, created_at, pr_state, contributors)
        contribution = Contribution.find_or_create_by(
          repository_id: rid,
          link:,
          created_at:,
          pr_state:
          )
          
        associate_users_with_contribution(contributors, contribution)
        
        contribution
      end
      
      def associate_users_with_contribution(contributors, contribution)
        contribution.users = contributors
        contribution.save
      end
    end
  end
end
