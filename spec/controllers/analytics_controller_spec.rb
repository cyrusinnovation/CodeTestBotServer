require 'spec_helper'

describe AnalyticsController do
  before {
    Figaro.env.stub(:from_address => 'test.from@example.com')
    Figaro.env.stub(:new_submission_address => 'test.to@example.com')
    Figaro.env.stub(:submissions_bucket => 'codetestbot-submissions-test')
    Figaro.env.stub(:aws_access_key_id => 'fake_key')
    Figaro.env.stub(:aws_secret_access_key => 'fake_secret')
  }

  describe '#index' do
    subject(:response) { get :index }

    it_behaves_like 'a secured route'

    context 'with an active session' do
      before { add_user_to_session('Assessor') }

      it { should be_ok }

      context 'when there are no submissions' do
        its(:body) { should have_json_size(0).at_path('analytics') }
      end

      context 'when there is a submission' do
        let(:language) { Language.find_by_name('Java') }
        let(:level) { Level.find_by_text('Junior') }
        let!(:submission) { Submission.create({email_text: 'test', language: language, candidate_name: 'Bob', candidate_email: 'bob@example.com', level: level}) }
        let(:expected) { [{email_text: 'test', zipfile: nil, resumefile: nil, average_score: nil, active: true, language_id: language.id, level_id: level.id, candidate_name: 'Bob', candidate_email: 'bob@example.com', source: nil, github: nil}].to_json }

        subject(:body) { response.body }

        it { should be_json_eql(expected).at_path('analytics') }
        it { should be_json_eql([{name: language.name}].to_json).at_path('languages') }
        it { should be_json_eql([{text: level.text}].to_json).at_path('levels') }
      end

      context 'when there are multiple submissions they should be ordered by latest first' do
        let(:language) { Language.find_by_name('Java') }
        let(:level) { Level.find_by_text('Junior') }
        let!(:submission) { Submission.create({email_text: 'test1', language: language, candidate_name: 'Submission One', candidate_email: 'bob@example.com', level: level}) }
        let!(:submission2) { Submission.create({email_text: 'test2', language: language, candidate_name: 'Submission Two', candidate_email: 'bob@example.com', level: level}) }
        let(:expected) { [{email_text: 'test2', zipfile: nil, resumefile: nil, active: true, average_score: nil, language_id: language.id, level_id: level.id, candidate_name: 'Submission Two', candidate_email: 'bob@example.com', source: nil, github: nil},
                          {email_text: 'test1', zipfile: nil, resumefile: nil, active: true, average_score: nil, language_id: language.id, level_id: level.id, candidate_name: 'Submission One', candidate_email: 'bob@example.com', source: nil, github: nil}].to_json }

        subject(:body) { response.body }

        it { should be_json_eql(expected).at_path('analytics') }
      end

    end
  end
end
