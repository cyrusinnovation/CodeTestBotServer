class EmailController < ApplicationController
  def submission_summary
    submission = Submission.find(params[:id])
    AssessmentsForClosedSubmissionMailer.closed_submission_summary(submission)
    render nothing: true, status: 200
  end
end
