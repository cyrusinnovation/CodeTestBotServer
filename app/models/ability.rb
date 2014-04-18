class Ability  
  include CanCan::Ability  
  
  def initialize(user)
    user.roles.each { |role| send(role.name.downcase) }
  end

  def assessor
    can :read, :all
  end

  def recruiter
    assessor
    can :manage, Candidate
    can :create, Submission
  end

  def administrator
    can :manage, :all
  end
end 