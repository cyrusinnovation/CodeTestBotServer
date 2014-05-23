module Policies
  class SubmissionClose
    def self.apply(submission)
      limit = 3
      if submission.assessments.length >= limit
        submission.close
        Notifications::Submissions.closed_by_assessments(submission)
      end
    end
  end
end

