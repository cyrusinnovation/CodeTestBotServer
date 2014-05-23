class SubmissionMailer < ActionMailer::Base
  def new_submission(submission)
    extract(submission)
    mail(to: Figaro.env.new_submission_address,
         from: Figaro.env.from_address,
         subject: "[CTB] #{@level.text} #{@language.name} Submission")
  end

  def closed_by_assessments(submission)
    extract(submission)
    @limit = 3
    mail(to: Figaro.env.new_assessment_address,
         from: Figaro.env.from_address,
         subject: "[CTB] Closed Submission for #{@candidate_name}")
  end

  private

  def extract(submission)
    @candidate_name = submission.candidate_name
    @level = submission.level
    @language = submission.language
    @url = "#{Figaro.env.app_uri}/submissions/#{submission.id}"
    @report_url = "#{@url}/report"
  end
end
