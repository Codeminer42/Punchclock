# frozen_string_literal: true

class MentoringQuery
  def initialize(relation = User)
    @relation = relation
  end

  def call
    relation
      .joins(mentor: :office)
      .select(
        'array_agg(users.name) as mentee_list',
        'mentors_users.name as name',
        "offices.city as office_city"
      )
      .active
      .group('mentors_users.name', "offices.city")
      .order("offices.city")
  end

  private

  attr_reader :relation
end
