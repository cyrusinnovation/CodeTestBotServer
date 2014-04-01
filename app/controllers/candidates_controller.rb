class CandidatesController < ApplicationController
  def create
    candidate = params[:candidate]
    Candidate.create(name: candidate[:name], email: candidate[:email])
  end

  def index
    render :json => Candidate.all
  end
end