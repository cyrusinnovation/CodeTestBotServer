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
  it { should respond_to(:level)}
  
  it 'has a language' do
    java = Language.find_by_name('Java')
    Submission.create(language: java)

    expect(Submission.first.language.name).to eql(java.name)
  end

  it 'has a level' do
    level = Level.find_by_text('Junior')
    Submission.create(level: level)

    expect(Submission.first.level).to eql(level)
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

  describe '.all_with_average_score' do 
    let(:submission)   { Submission.create() }
    let!(:submission_2) { Submission.create() }
    let!(:assessment1) {Assessment.create({submission: submission, score: 1})}
    let!(:assessment2) {Assessment.create({submission: submission_2, score: 3})}

    pending 'returns all submissions' do
      expect(Submission.all_with_average_score).to match_array([submission.as_json, submission_2.as_json])
    end

    it 'calls average_published_assessment_score on each submission' do
      submission
      expect(submission).to receive(:average_published_assessment_score)
      Submission.all_with_average_score
    end

    it 'returns a submission with an average score as a hash'
    it 'returns all submissions as an array of hashes each with an average score'

    it 'does not include scores for unpublished assesments in the average score' do
      assessment_3 = Assessment.create(submission_id: submission.id, score: 3, published: false)
      all_submissions = Submission.all_with_average_score

      expect(all_submissions.first[:average_score].to_int).to eq 1
    end
  end

  describe '#average_published_assessment_score' do 
    it 'returns its own average assessment score' do 
      submission      = Submission.create()
      assessment      = Assessment.create(submission_id: submission.id, score: 1)
      assessment_2    = Assessment.create(submission_id: submission.id, score: 3)
    
      expect(submission.average_published_assessment_score).to eq 2
    end
  end

  describe '.create_from_json' do
    let(:file) { Tempfile.new('codetestbot-submission') }
    let(:email_text) { 'a new code test.' }
    let(:language) { Language.find_by_name('Java') }
    let(:level) { Level.find_by_text('Junior') }
    let(:params) { {submission: {
      email_text: email_text, 
      candidate_name: 'Bob',
      candidate_email: 'bob@example.com',
      level_id: level.id, 
      language_id: language.id,
      source: 'LinkedIn'
    }}}

    subject(:creation) { Submission.create_from_json(params[:submission]) }

    it 'creates a new submission' do
      expect { creation }.to change(Submission, :count).from(0).to(1)
    end

    its(:email_text) { should eq email_text }
    its(:zipfile) { should be_nil }
    its(:candidate_name) { should eq 'Bob' }
    its(:candidate_email) { should eq 'bob@example.com' }
    its('level.text') { should eq level.text }
    its('language.name') { should eq language.name }
    its(:source) { should eq 'LinkedIn' }
  end

  describe '#close' do
    let(:submission) { Submission.create() }

    it 'sets the submission to inactive' do
      submission.close

      expect(Submission.find(submission.id).active).to be_false()
    end
  end

  describe '#attach_file' do
    let(:submission) { Submission.create() }

    it 'sets the zipfile attribute' do
      url = 'http://example.com'
      expect { submission.attach_file(url) }.to change(submission, :zipfile).from(nil).to(url)
    end
  end

  describe '.all_active' do
    let(:active) { Submission.create!({ active: true }) }
    let(:inactive) { Submission.create!({ active: false }) }

    subject { Submission.all_active }

    it { should include active }
    it { should_not include inactive }
  end
end
