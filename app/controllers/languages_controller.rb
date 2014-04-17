class LanguagesController < SecuredController
  def index
    render :json => Language.all
  end
end
