class AssessmentMailerPreview < ActionMailer::Preview
  def new_assessment
    AssessmentMailer.new_assessment(Assessment.first)
  end
end
