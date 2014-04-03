class LevelsController < ApplicationController
  def index
    render :json => Level.all
  end
end
