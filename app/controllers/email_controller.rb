class EmailController < UserAwareController
  def submission_summary
    submission = Submission.find(params[:id])
    AssessmentsForClosedSubmissionMailer.closed_submission_summary(submission, current_user.email)
    render nothing: true, status: 200
  end
end
