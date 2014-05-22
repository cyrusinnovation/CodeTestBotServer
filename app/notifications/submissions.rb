module Notifications
  class Submissions
    def self.new_submission(submission)
      SubmissionMailer.new_submission(submission).deliver
      WebHooks.new_submission(submission)
    end
  end
end
