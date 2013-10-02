class UserAbility
  include CanCan::Ability

  def initialize(user)
  	if user.is_admin?
    	can :manage, Punch, company_id: user.company.id
    	can :read, Company, id: user.company.id
      can :update, Company, id: user.company.id
    	can :manage, Project, company_id: user.company.id
      can :manage, User, company_id: user.company.id
      can :manage, Comment, user: { id: user.id }
      can :read, Comment, company_id: user.company_id
  	else
  		can :manage, Punch, company_id: user.company.id, user: { company: { id: user.company.id } }, project: { company: { id: user.company.id } }
      can :read, User, company_id: user.company.id
      can :manage, Comment, user: { id: user.id }
  	end
  end
end
