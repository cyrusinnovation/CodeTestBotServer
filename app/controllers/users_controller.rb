class UsersController < UserAwareController

  def index
    authorize! :view_users, User
    if params[:role_id] != nil
      role = Role.find(params[:role_id])
      users = role.users
    else
      users = User.all
    end
    render :json => users
  end

  def show
    authorize! :view_users, User
    user_id = params[:id]
    render :json => User.find(user_id)
  end

  def update
    authorize! :view_users, User
    user_id = params[:id]
    user = User.find(user_id)
    new_role_ids = params[:user][:role_ids]
    if new_role_ids.size == 0
      raise HttpStatus::Forbidden.new('Cannot remove all roles from a User.')
    end
    user.roles = new_role_ids.collect{|role_id| Role.find(role_id)}
    user.save
    render :json => user
  end

end
