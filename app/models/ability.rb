class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, ActiveAdmin::Page, :name => "Dashboard"

    if user.is_super?
      can :manage, AdminUser
      can :manage, Company
      can :manage, Project
      can :manage, User
      can :manage, Punch
    else
      can :manage, Company, :id => user.company.id
      can :manage, AdminUser, :company_id => user.company.id, :is_super => nil
    end
  end
end
