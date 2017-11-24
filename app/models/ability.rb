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
      can :manage, [AdminUser, User, Office, Project, Punch], company_id: user.company_id
      can :create, [AdminUser, Office, Project, User]
    end
    cannot :manage, RegionalHoliday #disable for now
  end

  def user_permitions(user)
    can :manage, Punch, company_id: user.company.id, user_id: user.id
    can :read, User, company_id: user.company.id
    can :edit, User, id: user.id
    can :update, User, id: user.id
    can :manage, Comment, user_id: user.id, company_id: user.company_id
  end
end
