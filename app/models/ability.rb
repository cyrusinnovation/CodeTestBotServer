class Ability  
  include CanCan::Ability  
  
  def initialize(user)
     admin_role = Role.find_by_name("Administrator")
     if user.roles.include? admin_role
      can :manage, :all  
    else  
      can :read, :all  
    end   
  end  
end 