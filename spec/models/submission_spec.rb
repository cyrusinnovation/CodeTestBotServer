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

  it 'correctly recalculates the average to 1 decimal' do
    java = Language.find_by_name('Java')
    submission = Submission.create(language: java)

    assessor_alice = Assessor.create({name: 'Alice'})
    assessment_alice = Assessment.create({submission: submission, assessor: assessor_alice, score: 4})

    assessor_bob = Assessor.create({name: 'Bob'})
    assessment_bob = Assessment.create({submission: submission, assessor: assessor_bob, score: 3})

    assessor_christine = Assessor.create({name: 'Christine'})
    assessment_christine = Assessment.create({submission: submission, assessor: assessor_christine, score: 3})

    expected_score = ((assessment_alice.score + assessment_bob.score + assessment_christine.score) / 3.0).round(1)

    submission.recalculate_average_score
    expect(Submission.find(submission.id).average_score).to eql(expected_score)
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
      language_id: language.id
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
