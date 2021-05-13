# frozen_string_literal: true

module ActiveAdmin
  module StatsHelper
    def constributions_offices_data(relation)
      Office.all.inject({}) do |result, office|
        contribution = relation.select { |r| r.city == office.city }.first
        amount = contribution.nil? ? 0 : contribution.number_of_contributions
        result[office.city] = amount
        result
      end
    end

    def constributions_users_data(contributions:, limit:)
      contribs = contributions.sort_by { |id, quantity| quantity }.reverse.first(limit)

      contribs.inject({}) do | result, contribution |
        user = User.find_by(id: contribution.first)
        result[user.name] = contribution.last
        result
      end
    end
  end
end
