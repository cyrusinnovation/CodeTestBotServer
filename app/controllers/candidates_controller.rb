class CandidatesController < UserAwareController
  def create
    authorize! :create, Candidate
    candidate = params[:candidate]
    level = Level.find(candidate[:level_id])
    render :json => Candidate.create(name: candidate[:name], email: candidate[:email], level: level), :status => :created
  end

  def index
    authorize! :view_full, Candidate
    render :json => Candidate.all
  end
end