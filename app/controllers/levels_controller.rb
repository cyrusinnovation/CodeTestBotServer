class LevelsController < ApplicationController
  def show
    render :json => Level.all
  end
end
