class SubmissionCreator
  def self.create_submission(submission)
    created_submission = Submission.create_from_json(submission)

    zipfile_name = submission[:zipfile_name]
    if zipfile_name
      zipfile_url = SubmissionFileUploader.upload(created_submission.id,
                                                  submission[:zipfile],
                                                  zipfile_name,
                                                  'codetest')
      created_submission.attach_zipfile(zipfile_url)
    end

    resumefile_name = submission[:resumefile_name]
    if resumefile_name
      resumefile_url = SubmissionFileUploader.upload(created_submission.id,
                                                     submission[:resumefile],
                                                     resumefile_name,
                                                     'resume')
      created_submission.attach_resumefile(resumefile_url)
    end

    Notifications::Submissions.new_submission(created_submission)
    created_submission
  end
end
