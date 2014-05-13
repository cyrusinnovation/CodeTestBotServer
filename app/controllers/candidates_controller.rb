class CandidatesController < UserAwareController
  def create
    authorize! :create, Candidate
    candidate = params[:candidate]
    level = Level.find(candidate[:level_id])
    render :json => Candidate.create(name: candidate[:name], email: candidate[:email], level: level), :status => :created
  end

  def index
    authorize! :view_full, Candidate

    filters = {}
    if params.include? :email
      filters[:email] = params[:email]
    end

    render :json => Candidate.all.where(filters)
  end
end