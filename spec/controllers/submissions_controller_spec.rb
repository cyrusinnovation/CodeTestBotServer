require 'spec_helper'

describe SubmissionsController do

  describe "POST" do
    it "saves the email text" do
      email_text = "a new code test."
      post :create, email_text: email_text
      expect(response).to be_success
      expect(Submission.count).to eql(1)
      expect(Submission.last.email_text).to eq email_text
    end

    it "can upload a zipfile" do
      @file = fixture_file_upload('files/test-codetest.zip', 'zip')
      post :create, zipfile: @file
      expect(response).to be_success
      expect(Submission.count).to eql(1)
      expect(Submission.last.zipfile.url).to include "test-codetest.zip" 
    end

  end
end
