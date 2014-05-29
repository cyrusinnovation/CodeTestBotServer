
class SubmissionCreator
  def self.create_submission(submission)
    file = Base64FileDecoder.decode_to_file(submission[:zipfile])
    submission[:zipfile] = S3Uploader.upload(file).to_s
    created_submission = Submission.create_from_json(submission)
    Notifications::Submissions.new_submission(created_submission)
    created_submission
  end
end

