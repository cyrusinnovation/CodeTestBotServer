require 'spec_helper'

describe Jobs::ApplyPolicies do
  describe '.apply_all' do
    it 'applies SubmissionClose policy to all active submissions' do
      submission1, submission2 = double, double
      Submission.stub(:all_active => [submission1, submission2])
      Policies::SubmissionClose.stub(:apply)

      Jobs::ApplyPolicies.apply_all

      expect(Policies::SubmissionClose).to have_received(:apply).with(submission1)
      expect(Policies::SubmissionClose).to have_received(:apply).with(submission2)
    end
  end
end

