# frozen_string_literal: true

class ContributionsByOfficeQuery
  def initialize(relation = Office.all)
    @relation = relation
                      .left_outer_joins(users: :contributions)
                      .select('offices.city, COUNT(contributions.id) AS number_of_contributions')
                      .group('offices.id')
  end

  def to_relation
    @relation
  end

  def by_company(company)
    @relation = @relation.by_company(company)

    self
  end

  def leaderboard(limit = 5)
    @relation = @relation.order('number_of_contributions DESC').limit(limit)

    self
  end

  def per_month(month)
    date = Date.today.change(day: 1, month: month)
    @relation = @relation.where("contributions.created_at >= :start_date AND contributions.created_at <= :end_date",
                                 start_date: date.beginning_of_month, end_date: date.end_of_month)

    self
  end

  def n_weeks_ago(n)
    @relation = @relation.where("contributions.created_at >= :start_date AND contributions.created_at <= :end_date",
                                 start_date: n.week.ago.beginning_of_week, end_date: n.week.ago.end_of_week)

    self
  end

  def this_week
    @relation = @relation.where("contributions.created_at >= :start_date", start_date: Date.today.beginning_of_week)
    
    self
  end

  def approved
    @relation = @relation.where('contributions.state = :approved', approved: 'approved')
    
    self
  end
end
