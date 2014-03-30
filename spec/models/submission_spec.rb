require 'spec_helper'

describe Submission do
  before do
    FakeWeb.allow_net_connect = false
  end

  it { should respond_to(:zipfile) }
  it { should respond_to(:email_text)}
  
  it 'has zipfile attachments that can be added and removed' do
    FakeWeb.register_uri(:put, 'https://codetestbot-submissions-test.s3.amazonaws.com/tmp/test/uploads/test-codetest.zip', :body => '')
    FakeWeb.register_uri(:head, 'https://codetestbot-submissions-test.s3.amazonaws.com/tmp/test/uploads/test-codetest.zip', :body => '')

    submission = Submission.new
    expect(submission.zipfile.url()).to eq "/zipfiles/original/missing.png"
    
    test_zipfile_attachment = File.new(Rails.root.to_s + "/spec/fixtures/files/test-codetest.zip")
    submission.update_attributes(:zipfile => test_zipfile_attachment)
    expect(submission.zipfile.url()).to include "test-codetest.zip"

    submission.zipfile.clear
    expect(submission.zipfile.url()).to eq "/zipfiles/original/missing.png" 
  end
end
