require 'spec_helper'

describe Submission do
  
  it { should respond_to(:zipfile) }
  it { should respond_to(:email_text)}
  
  it 'has zipfile attachments that can be added and removed' do

    submission = Submission.new
    expect(submission.zipfile.url()).to eq "/zipfiles/original/missing.png"
    
    test_zipfile_attachment = File.new(Rails.root.to_s + "/spec/fixtures/files/test-codetest.zip")
    submission.update_attributes(:zipfile => test_zipfile_attachment)
    expect(submission.zipfile.url()).to include "test-codetest.zip"

    submission.zipfile.clear
    expect(submission.zipfile.url()).to eq "/zipfiles/original/missing.png" 
  end
end
