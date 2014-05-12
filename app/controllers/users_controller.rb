class UsersController < UserAwareController

  def index
    authorize! :view_users, User
    render :json => User.all
  end

end
