# frozen_string_literal: true

class AbilityAdmin
  include CanCan::Ability
  prepend Draper::CanCanCan

  # Actions used by admins and super admins

  def initialize(user)
    return if user.nil?

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
      Note,
      Vacation
    ]

    admin_permitions(user) if user.admin?
    open_source_manager_permissions(user) if user.open_source_manager?
  end

  private

  attr_reader :action

  def admin_permitions(user)
    can :manage, action + [
      Punch,
      Vacation
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
    can :read, ActiveAdmin::Page, name: 'Vacation'
    
    cannot :destroy, [User, Project]
  end

  def open_source_manager_permissions(user)
    can :read, ActiveAdmin::Page, name: 'Dashboard'
    can :read, ActiveAdmin::Page, name: 'Stats'
    can :manage, Repository
    can :manage, Contribution
    can :create, Repository
  end
end
