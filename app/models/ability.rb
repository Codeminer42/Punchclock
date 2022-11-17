# frozen_string_literal: true

class Ability
  include CanCan::Ability
  prepend Draper::CanCanCan

  def initialize(user)
    return if user.nil?

    can :manage, Punch, user_id: user.id
    can :read, User, id: user.id
    can %i[edit update], User, id: user.id

    if user.admin? || user.evaluator? || user.office_head?
      can :manage, Evaluation
      can :manage, Note
      can :read, Vacation
      cannot %i[destroy edit update], Evaluation
    end

    if user.admin? || user.open_source_manager?
      can :read, ActiveAdmin
    end

    if user.hr? || user.project_manager?
      can :manage, Vacation
    end
  end
end
