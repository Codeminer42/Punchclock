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
      Client,
      RegionalHoliday,
      Evaluation,
      Questionnaire,
      Skill,
      Repository,
      Contribution,
      Note
    ]
    if user.is_admin?
      admin_permitions(user)
    elsif user.open_source_manager?
      open_source_manager_permitions(user)
    end
  end

  private

  attr_reader :action

  def admin_permitions(user)
    if user.super_admin?
      can :manage, action + [
        Company,
        Punch
      ]
    else
      can :manage, action, company_id: user.company_id
      can :read, Punch, company_id: user.company_id
      can :manage, Punch, user_id: user.id
      can :create, action
    end

    can :read, ActiveAdmin::Page, name: 'Dashboard'
    can :read, ActiveAdmin::Page, name: 'Stats'
    can :read, ActiveAdmin::Page, name: 'Allocation Chart'

    cannot :destroy, [User, Project]
  end

  def open_source_manager_permitions(user)
    can :read, ActiveAdmin::Page, name: 'Dashboard'
    can :read, ActiveAdmin::Page, name: 'Stats'
    can :manage, Repository, company_id: user.company_id
    can :manage, Contribution, company_id: user.company_id
    can :create, Repository
  end
end
