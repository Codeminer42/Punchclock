class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_super?
      can :manage_all, Company
    else
      can :manage_own, Company
    end
  end
end
