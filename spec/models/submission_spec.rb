require 'spec_helper'

describe Submission do
  before do
    FakeWeb.allow_net_connect = false

    env = fake_env
    allow(env).to receive(:submissions_bucket).and_return('codetestbot-submissions-test')
    allow(env).to receive(:aws_access_key_id).and_return('fake_key')
    allow(env).to receive(:aws_secret_access_key).and_return('fake_secret')
  end

  after do
    FakeWeb.allow_net_connect = true
  end

  it { should respond_to(:zipfile) }
  it { should respond_to(:email_text)}
  it { should respond_to(:candidate)}
  
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

  it 'belongs to a candidate' do
    candidate = Candidate.create(name: 'Bob')
    submission = Submission.create(candidate: candidate)

    expect(Submission.find(submission.id).candidate_id).to eql(candidate.id)
  end

  it 'has a language' do
    java = Language.find_by_name('Java')
    Submission.create(language: java)

    expect(Submission.first.language.name).to eql(java.name)
  end

  it 'has a list of assessments and assessors through assessments' do
    java = Language.find_by_name('Java')
    submission = Submission.create(language: java)
    assessor = Assessor.create({name: 'Bob'})
    assessment = Assessment.create({submission: submission, assessor: assessor, score: 1})

    expect(submission.assessments.size).to eql(1)
    expect(submission.assessors.size).to eql(1)
    expect(submission.assessments.first).to eql(assessment)
    expect(submission.assessors.first).to eql(assessor)
  end
end
