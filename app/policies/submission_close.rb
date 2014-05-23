module Policies
  class SubmissionClose
    def self.apply(submission)
      limit = 3
      submission.close if submission.assessments.length >= limit
    end
  end
end

