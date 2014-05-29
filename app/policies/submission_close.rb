module Policies
  class SubmissionClose
    def self.apply(submission)
      if should_apply?(submission)
        submission.close
        Notifications::Submissions.closed_by_assessments(submission)
      end
    end

    private

    def self.should_apply?(submission)
      limit = 3
      min_age = 1.hour
      submission.assessments.length >= limit && submission.assessments.all? {|a| a.age >= min_age }
    end
  end
end

