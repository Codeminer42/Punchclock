class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_admin?
      admin_permitions(user)
    else
      user_permitions(user)
    end
  end

  def all_permitions(user)
    can :read, Notification, user_id: user.id
    can :update, Notification, user_id: user.id
  end

  def admin_permitions(user)
    can :manage, Punch, company_id: user.company.id
    can :read, Company, id: user.company.id
    can :update, Company, id: user.company.id
    can :manage, Project, company_id: user.company.id
    can :manage, User, company_id: user.company.id
    can :read, Comment, company_id: user.company_id
    can :manage, Comment, user_id: user.id, company_id: user.company_id
    all_permitions(user)
  end

  def user_permitions(user)
    can :manage, Punch, company_id: user.company.id, user_id: user.id
    can :read, User, company_id: user.company.id
    can :edit, User, id: user.id
    can :update, User, id: user.id
    can :manage, Comment, user_id: user.id, company_id: user.company_id
    all_permitions(user)
  end
end
