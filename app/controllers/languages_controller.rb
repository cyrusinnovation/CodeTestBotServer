class LanguagesController < ApplicationController
  def show
    render :json => Language.all
  end
end
