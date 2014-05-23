module Notifications
  class Submissions
    def self.new_submission(submission)
      SubmissionMailer.new_submission(submission).deliver
      WebHooks.new_submission(submission)
    end

    def self.closed_by_assessments(submission)
      SubmissionMailer.closed_by_assessments(submission).deliver
    end
  end
end
