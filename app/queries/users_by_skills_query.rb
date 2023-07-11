# frozen_string_literal: true

class UsersBySkillsQuery
  def self.where(ids: [])
    new(ids: ids).where
  end

  def initialize(ids: [])
    @ids = ids
  end

  def where
    User.where(id: users_subquery)
  end

  private

  attr_reader :ids

  def users_subquery
    User.select('user_id as id')
        .where('skills_ids @> array[?]::bigint[]', ids)
        .from(skills_user_subquery)
  end

  def skills_user_subquery
    UserSkill.select(:user_id, 'array_agg(skill_id) as skills_ids')
             .group(:user_id)
  end
end
