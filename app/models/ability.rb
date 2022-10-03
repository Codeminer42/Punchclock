# frozen_string_literal: true

class Ability
  include CanCan::Ability
  prepend Draper::CanCanCan

  def initialize(user)
    can :manage, Punch, user_id: user.id
    can :read, User, id: user.id
    can %i[edit update], User, id: user.id

    if user.admin? || user.evaluator? || user.office_head?
      can :manage, Evaluation
      can :manage, Note
      cannot %i[destroy edit update], Evaluation
    end

    if user.admin?
      can :read, ActiveAdmin
    end
  end
end
