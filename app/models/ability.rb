class Ability
  include CanCan::Ability

  def initialize(user)
    user_permitions(user)
  end

  def all_permitions(user)
    can :read, Notification, user_id: user.id
    can :update, Notification, user_id: user.id
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
