class UsersController < UserAwareController

  def index
    authorize! :view_users, User
    render :json => User.all 
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
    role = Role.find(params[:user][:role_id])
    user.role = role
    user.save
    render :json => user
  end
end
