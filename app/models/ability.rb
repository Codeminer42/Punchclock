class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_a?(AdminUser)
      admin_user_permitions(user)
    else
      user_permitions(user)
    end
  end

  private

  def admin_user_permitions(user)
    if user.is_super?
      can :manage, :all
    else
      can :manage, [AdminUser, User, Office, Project, Punch, Client], company_id: user.company_id
      can :manage, RegionalHoliday
      can :create, [AdminUser, Office, Project, User, Client]
      cannot :create, Punch
    end
  end

  def user_permitions(user)
    can :manage, Punch, company_id: user.company_id, user_id: user.id
    can :read, User, company_id: user.company_id
    can :edit, User, id: user.id
    can :update, User, id: user.id
  end
end
