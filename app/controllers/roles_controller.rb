class RolesController < ApplicationController
  def index
    render :json => Role.all
  end

  def assign_role_to_user
  	role_change = params[:role_change]
    user = User.find(role_change[:user_id])
    role = Role.find(role_change[:role_id])
    user.role_id = role.id
    user.save
  end
end
