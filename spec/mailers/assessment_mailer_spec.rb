require 'spec_helper'
require 'mailer_spec_helper'

describe AssessmentMailer do
  include MailerSpecHelper

  let(:new_assessment_address1) { 'test.assessment1@example.com' }
  let(:new_assessment_address2) { 'test.assessment2@example.com' }
  let(:from_address) { 'test.from@example.com' }

  before(:each) do
    Figaro.env.stub(:new_assessment_address => "#{new_assessment_address1}, #{new_assessment_address2}")
    Figaro.env.stub(:from_address => from_address)
    Figaro.env.stub(:app_uri => 'http://example.com')
  end

  describe '#new_assessment' do
    let(:candidate) { Candidate.new({ name: 'Test Candidate', email: 'test.candidate@example.com' }) }
    let(:submission) { Submission.new({ candidate: candidate }) }
    let(:assessor) { Assessor.new({ name: 'Test Assessor', email: 'test.assessor@example.com' }) }
    let(:assessment) { Assessment.new({ id: 2, submission: submission, assessor: assessor }) }
    subject(:mail) { AssessmentMailer.new_assessment(assessment) }

    its(:to) { should include new_assessment_address1 }
    its(:to) { should include new_assessment_address2 }
    its(:from) { should include from_address }
    its(:subject) { should eq("[CTB] Assessment for #{candidate.name}") }

    it 'body should match fixture' do
      expected = read_mailer_fixture(AssessmentMailer, 'new_assessment')
      expect(mail.body.to_s).to eq(expected)
    end
  end

end
