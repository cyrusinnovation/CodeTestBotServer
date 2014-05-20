class AssessmentMailer < ActionMailer::Base
  def new_assessment(assessment)
    @assessor = assessment.assessor
    @candidate = assessment.submission.candidate
    @url = "#{Figaro.env.app_uri}/assessments/#{assessment.id}"
    mail(to: Figaro.env.new_assessment_address,
         from: Figaro.env.from_address,
         subject: "[CTB] Assessment for #{@candidate.name}")
  end
end
