class RolesController < UserAwareController

  def index
    authorize! :read, Role
    render :json => Role.all
  end

end
