module Github
  module Contributions
    class EngineersWrapper
      def initialize(company:)
        @company = company
      end

      def get_engineer_id_by_github_user(github_user)
        engineers.to_h[github_user]
      end

      def to_query
        engineers.map do |github_user, _user_id|
          "author:#{github_user}"
        end.join(' ')
      end

      def empty?
        engineers.empty?
      end

      attr_reader :company

      private 

      def engineers
        @engineers ||= company.users
          .engineer
          .active
          .pluck(:github, :id)
      end

      def to_h
        engineers.to_h
      end
    end
  end
end
