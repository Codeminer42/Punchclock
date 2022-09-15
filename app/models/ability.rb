# frozen_string_literal: true

class Ability
  include CanCan::Ability
  prepend Draper::CanCanCan

  def initialize(user)
    can :manage, Punch, user_id: user.id
    can :read, User, id: user.id
    can %i[edit update], User, id: user.id

    if !user.normal? || user.office_head?
      can :manage, Evaluation
      can :manage, Note
      cannot %i[destroy edit update], Evaluation
    end

    if user.is_admin? || user.office_head?
      can :manage, Note
    end
  end
end
