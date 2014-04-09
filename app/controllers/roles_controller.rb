class RolesController < UserAwareController

  def index
    authorize! :read, User
    render :json => Role.all
  end

  def assign_role_to_user
  	authorize! :assign_role, User
  	role_change = params[:role_change]
    user = User.find(role_change[:user_id])
    role = Role.find(role_change[:role_id])
    if not user.roles.include? role
      user.roles.push(role)
      user.save
    end
  end
end
