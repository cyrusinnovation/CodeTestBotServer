class AssessmentsController < UserAwareController
  def create
    assessment = params[:assessment]
    submission = Submission.find(assessment[:submission_id])
    assessor = Assessor.find(assessment[:assessor_id])

    created_assessment = Assessment.create({
                                              submission: submission,
                                              assessor: assessor,
                                              score: assessment[:score],
                                              notes: assessment[:notes]
                                          })
    AssessmentMailer.new_assessment(created_assessment).deliver
    render :json => created_assessment,
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


  def update
    assessment = Assessment.find(params[:id])
    if current_user.id != assessment.assessor_id
      raise HttpStatus::Forbidden.new('You can only edit your own assessments')
    end
    updated_assessment = params[:assessment]
    assessment.notes = updated_assessment[:notes]
    assessment.score = updated_assessment[:score]
    assessment.save
    render :json => assessment
  end
end
