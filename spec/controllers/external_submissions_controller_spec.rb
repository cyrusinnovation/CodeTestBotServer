require 'spec_helper'

describe ExternalSubmissionsController do
  before {
    Figaro.env.stub(:from_address => 'test.from@example.com')
    Figaro.env.stub(:new_submission_address => 'test.to@example.com')
    Figaro.env.stub(:submissions_bucket => 'codetestbot-submissions-test')
    Figaro.env.stub(:aws_access_key_id => 'fake_key')
    Figaro.env.stub(:aws_secret_access_key => 'fake_secret')
  }

  describe '#create' do
    let(:file) { Tempfile.new('codetestbot-submission') }
    let(:email_text) { 'a new code test.' }
    let(:language) { Language.find_by_name('Java') }
    let(:level) { Level.find_by_text('Junior') }
    let(:params) { {submission: {email_text: email_text, zipfile: 'header,====', candidate_name: 'Bob', level_id: level.id.to_s, language_id: language.id.to_s}}.with_indifferent_access }
    let(:submission) { Submission.new({ language: language }) }

    before {
      SubmissionCreator.stub(:create_submission => submission)
    }

    subject(:response) { post :create, params }

    it 'should create a submission' do
      expect(response).to be_created
      expect(SubmissionCreator).to have_received(:create_submission).with(params[:submission])
    end
  end
end