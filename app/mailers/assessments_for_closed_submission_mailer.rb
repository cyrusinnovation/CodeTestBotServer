class AssessmentsForClosedSubmissionMailer < ActionMailer::Base

  def closed_submission_summary(submission)
    extract(submission)
    extract_assessments(submission)
    mail(
      to: Figaro.env.recruiter_address,
      from: Figaro.env.from_address,
      subject: "[CTB] #{@candidate_name}: #{@level.text} #{@language.name} Closed Submission with Assessments"
    )
  end

  private

  def extract(submission)
    @candidate_name = submission.candidate_name
    @level = submission.level
    @language = submission.language
    @url = "#{Figaro.env.app_uri}/submissions/#{submission.id}"
    @report_url = "#{@url}/report"
  end

  def extract_assessments(submission)
    @assessments = submission.assessments
  end
end
