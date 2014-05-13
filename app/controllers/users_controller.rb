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
    updated_user = params[:user]
    user.roles = updated_user[:role_ids].collect{|role_id| Role.find(role_id)}
    user.save
    render :json => user
  end

end
