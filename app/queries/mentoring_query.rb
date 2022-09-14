# frozen_string_literal: true

class MentoringQuery
  attr_reader :relation

  def initialize(relation = User)
    @relation = relation
  end

  def call
    relation
      .joins(:reviewer, reviewer: [:office])
      .select(
        'array_agg(users.name) as mentees',
        'reviewers_users.name as name',
        :city
      )
      .group('reviewers_users.name', :city)
      .order(:city)
  end
end
