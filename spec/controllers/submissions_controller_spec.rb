require 'spec_helper'

describe SubmissionsController do
  before do
    FakeWeb.allow_net_connect = false
  end

  describe 'POST' do
    before do
      @file = Tempfile.new('codetestbot-submission')
      allow(Base64FileDecoder).to receive(:decode_to_file).and_return(@file)
      FakeWeb.register_uri(:put, "https://codetestbot-submissions-test.s3.amazonaws.com/tmp/test/uploads/#{File.basename(@file)}", :body => '')
    end

    it 'saves the email text' do
      email_text = 'a new code test.'
      post :create, {submission: {emailText: email_text, zipfile: 'header,===='}}
      expect(response).to be_success
      expect(Submission.count).to eql(1)
      expect(Submission.last.email_text).to eq email_text
    end

    it 'can upload a zipfile' do
      post :create, {submission: {emailText: '', zipfile: 'header,===='}}
      expect(response).to be_success
      expect(Submission.count).to eql(1)
      expect(Submission.last.zipfile.url).to include File.basename(@file)
    end

  end
end
