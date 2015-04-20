require 'spec_helper'

describe EmailController do

  describe "POST 'submission_summary'" do
    it "returns http success" do
      submission = Submission.create

      expect(AssessmentsForClosedSubmissionMailer).to receive(:closed_submission_summary).with(submission)

      post :submission_summary, id: submission.id
      response.status.should eq 200
    end
  end

end
