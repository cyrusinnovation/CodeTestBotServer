class UsersController < UserAwareController

  def index
    authorize! :view_users, User
    render :json => User.all
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

  def remove_role_from_user
    authorize! :remove_role, User
    role_change = params[:role_change]
    user = User.find(role_change[:user_id])
    role = Role.find(role_change[:role_id])
    if user.roles.include? role
      user.roles.delete(role)
      user.save
    end
  end

  def filter_by_role
    authorize! :view_roles, User
    role_name = params[:role_name]
    if not role_name
      raise 'You must give the name of the role to filter by'
    end
    role = Role.find_by_name(role_name)
    render :json => role.users
  end

end
