class AssessmentMailer < ActionMailer::Base
  def new_assessment(assessment)
    @assessor = assessment.assessor
    @candidate_name = assessment.submission.candidate_name
    @candidate_email = assessment.submission.candidate_email
    @url = "#{Figaro.env.app_uri}/submissions/#{assessment.submission.id}/assessments/#{assessment.id}"
    mail(to: Figaro.env.new_assessment_address,
         from: Figaro.env.from_address,
         subject: "[CTB] Assessment for #{@candidate_name}")
  end
end
