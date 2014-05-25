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
end
