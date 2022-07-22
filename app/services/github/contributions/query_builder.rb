module Github
  module Contributions
    class QueryBuilder
      QUERY_STRING_GH_SEARCH = 'created:%s is:pr %s %s'.freeze

      class << self
        def build_query_string(authors_query, repositories_query)
          QUERY_STRING_GH_SEARCH % [days_to_search, authors_query, repositories_query]
        end

        private

        def days_to_search
          days = ENV.fetch('DAYS_TO_SEARCH_CONTRIBUTIONS', 1).to_i
          days.day.ago.strftime('%Y-%m-%d')
        end
      end
    end
  end
end
