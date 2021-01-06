# frozen_string_literal: true

module ActiveAdmin
  module StatsHelper
    def stats_data(relation)
      Office.all.inject({}) do |result, office| 
        contribution = relation.select { |r| r.city == office.city }.first
        amount = contribution.nil? ? 0 : contribution.number_of_contributions
        result[office.city] = amount 
        result
      end
    end
  end
end
