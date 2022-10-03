# frozen_string_literal: true

class AbilityAdmin
  include CanCan::Ability
  prepend Draper::CanCanCan

  # Actions used by admins and super admins

  def initialize(user)
    @action = [
      Allocation,
      User,
      Office,
      Project,
      RegionalHoliday,
      Evaluation,
      Questionnaire,
      Skill,
      Repository,
      Contribution,
      Note
    ]

    admin_permitions(user) if user.admin?
  end

  private

  attr_reader :action

  def admin_permitions(user)
    can :manage, action + [
      Punch
    ]
    can :manage, action
    can :read, Punch
    can :manage, Punch, user_id: user.id
    can :create, action

    can :read, ActiveAdmin::Page, name: 'Dashboard'
    can :read, ActiveAdmin::Page, name: 'Stats'
    can :read, ActiveAdmin::Page, name: 'Allocation Chart'
    can :read, ActiveAdmin::Page, name: 'Revenue Forecast'
    can :read, ActiveAdmin::Page, name: 'Mentoring'
    
    cannot :destroy, [User, Project]
  end
end
