require 'spec_helper'

describe SubmissionCreator do
    let(:file_url) { '/some/url' }
    let(:submission_json) { { zipfile: 'header,====' } }
    let(:submission) { Submission.new({ id: 5}) }

    before {
      Submission.stub(:create_from_json).with(submission_json).and_return(submission)
      SubmissionFileUploader.stub(:upload => file_url)
      Notifications::Submissions.stub(:new_submission)
      submission.stub(:attach_file)
    }

    it 'creates and returns a submission' do
      expect(SubmissionCreator.create_submission(submission_json)).to eql submission
    end
    
    it 'uploads the file' do
      SubmissionCreator.create_submission(submission_json)
      expect(SubmissionFileUploader).to have_received(:upload).with(submission, submission_json[:zipfile])
    end

    it 'attaches the uploaded file to the submission' do
      SubmissionCreator.create_submission(submission_json)
      expect(submission).to have_received(:attach_file).with(file_url)
    end

    it 'should send notifications' do
      SubmissionCreator.create_submission(submission_json)
      expect(Notifications::Submissions).to have_received(:new_submission).with(submission)
    end
end

