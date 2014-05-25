class Ability  
  include CanCan::Ability  
  
  def initialize(user)
    send(user.role.name.downcase)
  end

  def assessor
    can :read, :all
  end

  def recruiter
    assessor
    can :manage, Submission
  end

  def administrator
    can :manage, :all
  end
end 
