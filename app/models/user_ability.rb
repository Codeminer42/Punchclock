class UserAbility
  include CanCan::Ability

  def initialize(user)
  	if user.is_admin?
    	can :manage, Punch, company: { id: user.company.id }
    	can :update, Company, id: user.company.id
  	else
  		can :manage, Punch, company_id: user.company.id, user: { company: { id: user.company.id } }, project: { company: { id: user.company.id } }
  	end
  end
end
