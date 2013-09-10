class UserAbility
  include CanCan::Ability

  def initialize(user)
    can :manage, Punch, company_id: user.company.id, user: { company: { id: user.company.id } }, project: { company: { id: user.company.id } }
  end
end
