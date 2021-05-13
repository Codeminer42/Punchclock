# frozen_string_literal: true

class ContributionsByUserQuery
  def initialize(relation = Contribution.all)
    @relation = relation
                  .joins(:user)
                  .group(:user_id)
  end

  def to_hash
    @relation.count(:user_id)
  end

  def by_company(company)
    @relation = @relation.where(company: company)

    self
  end

  def approved
    @relation = @relation.approved

    self
  end

  def per_month(month)
    date = Date.today.change(day: 1, month: month)
    @relation = @relation.where("contributions.created_at >= :start_date AND contributions.created_at <= :end_date",
                                 start_date: date.beginning_of_month, end_date: date.end_of_month)

    self
  end
end
