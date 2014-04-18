class LevelsController < SecuredController
  def index
    render :json => Level.all
  end
end
