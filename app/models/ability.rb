class Ability  
  include CanCan::Ability  
  
  def initialize(user)  
     if user.role and user.role.name == 'Administrator'  
      can :manage, :all  
    else  
      can :read, :all  
    end   
  end  
end 