class AssessorsController < ApplicationController
  def index
    render :json => Role.find_by_name("Assessor").users
  end
end
