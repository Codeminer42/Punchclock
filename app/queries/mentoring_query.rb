# frozen_string_literal: true

class MentoringQuery
  def initialize(relation = User)
    @relation = relation
  end

  def call
    relation
      .joins(reviewer: :office)
      .select(
        'array_agg(users.name) as mentees',
        'reviewers_users.name as name',
        "offices.city as office_city"
      )
      .active
      .group('reviewers_users.name', "offices.city")
      .order("offices.city")
  end

  private

  attr_reader :relation
end
