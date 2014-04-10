class Ability  
  include CanCan::Ability  
  
  def initialize(user)
     admin_role = Role.find_by_name("Administrator")
     recruiter_role = Role.find_by_name("Recruiter")
    if user.roles.include? admin_role
        can :manage, :all
    elsif user.roles.include? recruiter_role
        can :manage, Candidate
        can :create, Submission
        can :read, :all
    else  
        can :read, :all
    end   
  end  
end 