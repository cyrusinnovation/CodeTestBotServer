require 'spec_helper'

describe SubmissionCreator do
    let(:file_url) { '/some/url' }
    let(:submission_json) { {
                              zipfile: 'header,====',
                              zipfile_name: 'filename.zip',
                              resumefile: 'header,+++++',
                              resumefile_name: 'resumefile.pdf'
                            } }
    let(:submission) { Submission.new({ id: 5}) }

    before {
      Submission.stub(:create_from_json).with(submission_json).and_return(submission)
      SubmissionFileUploader.stub(:upload => file_url)
      Notifications::Submissions.stub(:new_submission)
      submission.stub(:attach_zipfile)
      submission.stub(:attach_resumefile)
    }

    it 'creates and returns a submission' do
      expect(SubmissionCreator.create_submission(submission_json)).to eql submission
    end

    it 'uploads the zipfile and attaches to submission' do
      SubmissionCreator.create_submission(submission_json)
      expect(SubmissionFileUploader).to have_received(:upload).with(submission, submission_json[:zipfile], 'filename.zip')
      expect(submission).to have_received(:attach_zipfile).with(file_url)
    end

    it 'uploads the resumefile and attaches to submission' do
      SubmissionCreator.create_submission(submission_json)
      expect(SubmissionFileUploader).to have_received(:upload).with(submission, submission_json[:resumefile], 'resumefile.pdf')
      expect(submission).to have_received(:attach_resumefile).with(file_url)
    end

    it 'should send notifications' do
      SubmissionCreator.create_submission(submission_json)
      expect(Notifications::Submissions).to have_received(:new_submission).with(submission)
    end
end
