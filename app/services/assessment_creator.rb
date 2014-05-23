class AssessmentCreator
  def self.create_assessment(assessment)
    created_assessment = Assessment.create_from_json(assessment)
    Notifications::Assessments.new_assessment(created_assessment)
    close_submission_if_limit_reached(created_assessment)
    created_assessment
  end

  private

  def self.close_submission_if_limit_reached(assessment)
    limit = 3
    submission = assessment.submission
    count = submission.assessments.length
    if count >= limit
      submission.close
    end
  end
end
