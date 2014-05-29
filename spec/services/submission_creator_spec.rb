require 'spec_helper'

describe SubmissionCreator do
    let(:file_url) { '/some/url' }
    let(:submission_json) { { zipfile: 'header,====' } }
    let(:modified_json) { json = submission_json.clone; json[:zipfile] = file_url; json }
    let(:submission) { Submission.new }

    before {
      file = double()
      Base64FileDecoder.stub(:decode_to_file).with(submission_json[:zipfile]).and_return(file)
      S3Uploader.stub(:upload).with(file).and_return(URI(file_url))
      Submission.stub(:create_from_json).with(modified_json).and_return(submission)
      Notifications::Submissions.stub(:new_submission)
    }

    it 'creates and returns a submission' do
      expect(SubmissionCreator.create_submission(submission_json)).to eql submission
    end

    it 'should send notifications' do
      SubmissionCreator.create_submission(submission_json)
      expect(Notifications::Submissions).to have_received(:new_submission).with(submission)
    end
end

