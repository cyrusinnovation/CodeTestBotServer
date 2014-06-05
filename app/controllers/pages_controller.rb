class PagesController < UserAwareController 
  def show
    render :json => Page.find_by_name(params[:id])
  end

  def update
    authorize! :update, Page
    render :json => Page.update_from_json(params[:id], params[:page])
  end
end
