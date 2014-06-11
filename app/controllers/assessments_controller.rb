class AssessmentsController < UserAwareController
  def create
    begin
      created_assessment = AssessmentCreator.create_assessment(params[:assessment])
      render :json => created_assessment,
             :status => :created
    rescue Assessment::ExistingAssessmentError
      render :json => { errors: ['You can only create one assessment per submission.'] },
             :status => :forbidden
    end

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

    include_unpublished = params[:include_unpublished] 
    unless include_unpublished
      filters[:published] = true
    end

    render :json => Assessment.all.where(filters)
  end


  def update
    assessment = Assessment.find(params[:id])
    if current_user.id != assessment.assessor_id
      raise HttpStatus::Forbidden.new('You can only edit your own assessments')
    end
    render :json => AssessmentCreator.update_assessment(assessment, params[:assessment]) end
end
