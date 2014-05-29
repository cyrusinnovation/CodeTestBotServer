module Jobs
  class ApplyPolicies
    def self.apply_all
      Submission.all_active.map(&Policies::SubmissionClose.method(:apply))
    end
  end
end

