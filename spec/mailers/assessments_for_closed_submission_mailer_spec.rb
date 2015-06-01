require 'spec_helper'
require 'mailer_spec_helper'
require 'pry'

describe AssessmentsForClosedSubmissionMailer do
  include MailerSpecHelper

  let(:recruiter_address) { 'closedassessment@example.com' }
  let(:from_address) { 'test.from@example.com' }

  before(:each) do
    Figaro.env.stub(:from_address => from_address)
    Figaro.env.stub(:app_uri => 'http://example.com')
  end

  describe '#closed_submission_summary' do
    let(:level) { Level.new({ text: 'Junior' }) }
    let(:language) { Language.new({ name: 'Java' }) }
    let(:submission) { Submission.new({ level: level, language: language, candidate_name: 'Mario Batali' }) }
    let(:assessor1) { Assessor.new({ name: 'Assessor1', role_id: 1 }) }
    let(:assessor2) { Assessor.new({ name: 'Assessor2', role_id: 1 }) }
    let(:assessment1) { Assessment.new({ assessor: assessor1, score: 3, pros: 'Pros1', cons: 'Cons1', notes: 'Notes1' }) }
    let(:assessment2) { Assessment.new({ assessor: assessor2, score: 2, pros: 'Pros2', cons: 'Cons2', notes: 'Notes2' }) }
    subject(:mail) { AssessmentsForClosedSubmissionMailer.closed_submission_summary(submission, recruiter_address) }

    before(:each) do
      submission.assessments << [ assessment1, assessment2 ]
      submission.save
    end

    after(:each) do
      [assessment1, assessment2, assessor1, assessor2, submission].each(&:destroy)
    end

    its(:to) { should include recruiter_address }
    its(:from) { should include from_address }
    its(:subject) { should eq("[CTB] #{submission.candidate_name}: #{level.text} #{language.name} Closed Submission with Assessments") }
    
    it 'body should match fixture' do
      expected = read_mailer_fixture(AssessmentsForClosedSubmissionMailer, 'closed_submission_summary')
      expect(mail.body.to_s).to eq(expected)
      expect(AssessmentsForClosedSubmissionMailer.deliveries.first.subject).to include('Mario Batali')
    end

    it 'body should render markdown for pros, cons and notes' do 
      md_bold_pros = '**Markdown PROS**'
      md_italic_cons = 'Markdown _CONS_'
      md_bold_notes = 'Markdown **NOTES**'
      md_assessment1 = Assessment.new({ 
        assessor: assessor1, 
        score: 3, 
        pros: markdown_to_html(md_bold_pros), 
        cons: markdown_to_html(md_italic_cons), 
        notes: markdown_to_html(md_bold_notes) 
      })

      submission.assessments = [md_assessment1]
      submission.save

      expected = read_mailer_fixture(AssessmentsForClosedSubmissionMailer, 'closed_submission_summary_md')
      expect(mail.body.to_s).to eq(expected)
    end

  end
end
