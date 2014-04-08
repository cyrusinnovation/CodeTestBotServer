class CandidatesController < ApplicationController
  def create
    candidate = params[:candidate]
    level = Level.find(candidate[:level_id])
    render :json => Candidate.create(name: candidate[:name], email: candidate[:email], level: level)
  end

  def index
    render :json => Candidate.all
  end
end