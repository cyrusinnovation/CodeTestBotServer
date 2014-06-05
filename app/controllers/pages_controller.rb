class PagesController < ApplicationController
  def show
    render :json => Page.find_by_name(params[:id])
  end
end
