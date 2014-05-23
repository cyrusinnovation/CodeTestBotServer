class AssessmentCreator
  def self.create_assessment(assessment)
    created_assessment = Assessment.create_from_json(assessment)
    Notifications::Assessments.new_assessment(created_assessment)
    Policies::SubmissionClose.apply(created_assessment.submission)
    created_assessment
  end
end
