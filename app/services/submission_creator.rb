class SubmissionCreator
  def self.create_submission(submission)
    created_submission = Submission.create_from_json(submission)
    file_name = submission[:zipfile_name]
    file_url = SubmissionFileUploader.upload(created_submission, submission[:zipfile], file_name)
    created_submission.attach_zipfile(file_url)
    Notifications::Submissions.new_submission(created_submission)
    created_submission
  end
end
