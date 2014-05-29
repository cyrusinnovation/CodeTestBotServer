
class SubmissionCreator
  def self.create_submission(submission)
    created_submission = Submission.create_from_json(submission)
    file_url = SubmissionFileUploader.upload(created_submission, submission[:zipfile])
    created_submission.attach_file(file_url)
    Notifications::Submissions.new_submission(created_submission)
    created_submission
  end
end

