class AssessmentsController < SecuredController
  def create
    assessment = params[:assessment]
    submission = Submission.find(assessment[:submission_id])
    assessor = Assessor.find(assessment[:assessor_id])

    render :json => Assessment.create({
        submission: submission,
        assessor: assessor,
        score: assessment[:score],
        notes: assessment[:notes]
                      }),
           :status => :created
  end

  def show
    render :json => Assessment.find(params[:id])
  end

  def index
    filters = {}
    if params.include? :submission_id
      filters[:submission_id] = params[:submission_id]
    end

    if params.include? :assessor_id
      filters[:assessor_id] = params[:assessor_id]
    end

    render :json => Assessment.all.where(filters)
  end
end
