# frozen_string_literal: true

class Ability
  include CanCan::Ability
  prepend Draper::CanCanCan

  # Actions used by admins and super admins
  ACTIONS = [
    User,
    Office,
    Project,
    Client,
    RegionalHoliday,
    Evaluation,
    Questionnaire,
    Skill,
    Repository,
    Contribution
  ]

  def initialize(user)
    if user.is_admin?
      admin_permitions(user)
    elsif user.open_source_manager?
      open_source_manager_permitions(user)
    else
      user_permitions(user)
    end
  end

  private

  def admin_permitions(user)
    if user.super_admin?
      can :manage, ACTIONS + [
        Company,
        Punch
      ]
    else
      can :manage, ACTIONS, company_id: user.company_id
      can :read, Punch, company_id: user.company_id
      can :manage, Punch, user_id: user.id
      can :create, ACTIONS
    end

    can :read, ActiveAdmin::Page, name: "Dashboard"
    can :create, [Allocation]
    can :manage, Allocation, ['1=1'] do |allocation|
      allocation.id?
    end

    cannot :destroy, [User, Project]
  end

  def user_permitions(user)
    can :manage, Punch, company_id: user.company_id, user_id: user.id
    can :read, User, company_id: user.company_id
    can %i[edit update], User, id: user.id

    if !user.normal? || user.office_head?
      can :manage, Evaluation, company_id: user.company_id
      cannot %i[destroy edit update], Evaluation
    end
  end

  def open_source_manager_permitions(user)
    can :manage, Punch, company_id: user.company_id, user_id: user.id
    can :read, ActiveAdmin::Page, name: "Dashboard"
    can :read, User, company_id: user.company_id
    can %i[edit update], User, id: user.id

    can :manage, Repository, company_id: user.company_id
    can :manage, Contribution, company_id: user.company_id
    
    cannot :manage, User
  end
end
