class SubmissionMailer < ActionMailer::Base
  def new_submission(submission)
    @level = submission.level
    @language = submission.language
    @url = "#{Figaro.env.base_uri}/submissions/#{submission.id}"
    mail(to: Figaro.env.new_submission_address,
         from: Figaro.env.from_address,
         subject: "[CTB] #{@level.text} #{@language.name} Submission")
  end
end
