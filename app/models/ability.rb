# frozen_string_literal: true

class Ability
  include CanCan::Ability
  prepend Draper::CanCanCan

  def initialize(user)
    return if user.nil?

    can :manage, Punch, user_id: user.id
    can :read, User, id: user.id
    can %i[edit update], User, id: user.id
    can :read, Vacation, user_id: user.id
    can :destroy, Vacation do |vacation|
      vacation.cancelable?
    end

    unless user.vacations.any?(&:pending?)
      can :create, Vacation
    end

    if user.admin? || user.evaluator? || user.office_head?
      can :manage, Evaluation
      can :manage, Note
      can :read, Vacation
      cannot %i[destroy edit update], Evaluation
    end

    if user.admin? || user.open_source_manager?
      can :read, ActiveAdmin
      can :manage, Questionnaire
    end
  end
end
