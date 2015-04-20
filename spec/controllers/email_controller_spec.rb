require 'spec_helper'

describe EmailController do

  describe "POST 'submission_summary'" do
    before { add_user_to_session('Assessor') }

    it "returns http success" do
      expected_email = 'testemail@example.com'
      expect(controller).to receive(:current_user).and_return(double(:user, email: expected_email))

      submission = Submission.create

      expect(AssessmentsForClosedSubmissionMailer).to receive(:closed_submission_summary).with(submission, expected_email)

      post :submission_summary, id: submission.id
      response.status.should eq 200
    end
  end

end
