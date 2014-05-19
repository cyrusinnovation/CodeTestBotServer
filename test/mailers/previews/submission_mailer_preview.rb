class SubmissionMailerPreview < ActionMailer::Preview
  def new_submission
    SubmissionMailer.new_submission(Submission.first)
  end
end