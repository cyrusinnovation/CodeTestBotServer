class RolesController < ApplicationController
  include CanCan::ControllerAdditions

  def index
    render :json => Role.all
  end

  def get_session
    authorization = request.headers['Authorization']
    type, token = authorization.split(' ')
    session = Session.find_by_token token
    return session
  end

  def current_user
    session = get_session
    return session.user
  end

  def assign_role_to_user
  	authorize! :edit, User
  	role_change = params[:role_change]
    user = User.find(role_change[:user_id])
    role = Role.find(role_change[:role_id])
    user.role_id = role.id
    user.save
  end
end
