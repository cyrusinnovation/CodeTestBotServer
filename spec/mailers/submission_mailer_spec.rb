require 'spec_helper'
require 'mailer_spec_helper'

describe SubmissionMailer do
  include MailerSpecHelper

  let(:new_assessment_address) { 'test.assessments@example.com' }
  let(:new_submission_address) { 'test.to@example.com' }
  let(:from_address) { 'test.from@example.com' }

  before(:each) do
    Figaro.env.stub(:new_assessment_address => new_assessment_address)
    Figaro.env.stub(:new_submission_address => new_submission_address)
    Figaro.env.stub(:from_address => from_address)
    Figaro.env.stub(:app_uri => 'http://example.com')
  end

  describe '#new_submission' do
    let(:level) { Level.new({ text: 'Junior' }) }
    let(:language) { Language.new({ name: 'Java' }) }
    let(:candidate) { Candidate.new({ level: level }) }
    let(:submission) { Submission.new({ id: 2, candidate: candidate, language: language }) }
    subject(:mail) { SubmissionMailer.new_submission(submission) }

    its(:to) { should include new_submission_address }
    its(:from) { should include from_address }
    its(:subject) { should eq("[CTB] #{level.text} #{language.name} Submission") }

    it 'body should match fixture' do
      expected = read_mailer_fixture(SubmissionMailer, 'new_submission')
      expect(mail.body.to_s).to eq(expected)
    end
  end

  describe '#closed_by_assessments' do
    let(:candidate) { Candidate.new({ name: 'Bob' }) }
    let(:submission) { Submission.new({ id: 2, candidate: candidate }) }
    subject(:mail) { SubmissionMailer.closed_by_assessments(submission) }

    its(:to) { should include new_assessment_address }
    its(:from) { should include from_address }
    its(:subject) { should eq("[CTB] Closed Submission for #{candidate.name}") }
    it 'body should match fixture' do
      expected = read_mailer_fixture(SubmissionMailer, 'closed_by_assessments')
      expect(mail.body.to_s).to eq(expected)
    end
  end
end
