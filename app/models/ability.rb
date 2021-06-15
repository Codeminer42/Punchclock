# frozen_string_literal: true

class Ability
  include CanCan::Ability
  prepend Draper::CanCanCan

  def initialize(user)
    can :manage, Punch, company_id: user.company_id, user_id: user.id
    can :read, User, company_id: user.company_id, id: user.id
    can %i[edit update], User, id: user.id

    if !user.normal? || user.office_head?
      can :manage, Evaluation, company_id: user.company_id
      can :manage, Note, company_id: user.company_id
      cannot %i[destroy edit update], Evaluation
    end

    if user.is_admin? || user.office_head?
      can :manage, Note, company_id: user.company_id
    end
  end
end
