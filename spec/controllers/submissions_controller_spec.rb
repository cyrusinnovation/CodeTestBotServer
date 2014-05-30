require 'spec_helper'

describe SubmissionsController do
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
        its(:body) { should have_json_size(0).at_path('submissions') }
      end

      context 'when there is a submission' do
        let(:language) { Language.find_by_name('Java') }
        let(:level) { Level.find_by_text('Junior') }
        let!(:submission) { Submission.create({email_text: 'test', language: language, candidate_name: 'Bob', candidate_email: 'bob@example.com', level: level}) }
        let(:expected) { [{email_text: 'test', zipfile: nil, active: true, language_id: language.id, level_id: level.id, candidate_name: 'Bob', candidate_email: 'bob@example.com'}].to_json }

        subject(:body) { response.body }

        it { should be_json_eql(expected).at_path('submissions') }
        it { should have_json_type(Integer).at_path('submissions/0/id') }
        it { should be_json_eql([{name: language.name}].to_json).at_path('languages') }
        it { should be_json_eql([{text: level.text}].to_json).at_path('levels') }
      end

      context 'when there are multiple submissions they should be ordered by latest first' do
        let(:language) { Language.find_by_name('Java') }
        let(:level) { Level.find_by_text('Junior') }
        let!(:submission) { Submission.create({email_text: 'test1', language: language, candidate_name: 'Submission One', candidate_email: 'bob@example.com', level: level}) }
        let!(:submission2) { Submission.create({email_text: 'test2', language: language, candidate_name: 'Submission Two', candidate_email: 'bob@example.com', level: level}) }
        let(:expected) { [{email_text: 'test2', zipfile: nil, active: true, language_id: language.id, level_id: level.id, candidate_name: 'Submission Two', candidate_email: 'bob@example.com'},
                          {email_text: 'test1', zipfile: nil, active: true, language_id: language.id, level_id: level.id, candidate_name: 'Submission One', candidate_email: 'bob@example.com'}].to_json }

        subject(:body) { response.body }

        it { should be_json_eql(expected).at_path('submissions') }
      end

    end
  end

  describe '#create' do
    let(:file) { Tempfile.new('codetestbot-submission') }
    let(:email_text) { 'a new code test.' }
    let(:language) { Language.find_by_name('Java') }
    let(:level) { Level.find_by_text('Junior') }
    let(:params) { {submission: {email_text: email_text, zipfile: 'header,====', candidate_name: 'Bob', level_id: level.id.to_s, language_id: language.id.to_s}}.with_indifferent_access }
    let(:submission) { Submission.new({ language: language }) }

    before {
      SubmissionCreator.stub(:create_submission => submission)
    }

    subject(:response) { post :create, params }

    it_behaves_like 'a secured route'

    %w(Recruiter Administrator).each do |role|
      context "when user has role #{role}" do
        before { add_user_to_session(role) }

        it 'should create a submission' do
          expect(response).to be_created
          expect(SubmissionCreator).to have_received(:create_submission).with(params[:submission])
        end
      end
    end

    context 'when user is unauthorized' do
      before { add_user_to_session('Assessor') }

      it { should be_forbidden }
    end
  end

  describe '#show' do
    let(:params) { {id: 0} }

    subject(:response) { get :show, params }

    it_behaves_like 'a secured route'

    context 'with an active session' do
      before { add_user_to_session('Assessor') }
      let!(:submission1) { Submission.create({email_text: 'first'}) }
      let!(:submission2) { Submission.create({email_text: 'second'}) }
      let(:params) { {id: submission2.id} }
      let(:expected) { {email_text: 'second', zipfile: nil, active: true, language_id: nil, candidate_name: nil, candidate_email: nil, level_id: nil}.to_json }

      it { should be_ok }
      its(:body) { should be_json_eql(expected).at_path('submission') }
    end
  end

  describe '#update' do
    let(:submission) { Submission.create({email_text: 'original'}) }
    let(:submission_id) { submission.id }

    subject(:response) { put :update, {id: submission_id, submission: {email_text: 'updated', active: false}} }

    it_behaves_like 'a secured route'

    %w(Recruiter Administrator).each do |role|
      context "when user has role #{role}" do
        before { add_user_to_session(role) }

        context 'when updating an existing submission' do
          let(:expected) { {email_text: 'updated', zipfile: nil, active: false, language_id: nil, candidate_name: nil, candidate_email: nil, level_id: nil}.to_json }

          it { should be_ok }
          its(:body) { should be_json_eql(expected).at_path('submission') }
          it 'should update the submission' do
            response
            expect(Submission.first.email_text).to eq('updated')
          end
        end

        context 'when updating a submission that does not exist' do
          let(:submission_id) { submission.id + 1 }
          it { should be_not_found }
        end
      end
    end

    context 'when user is unauthorized' do
      before { add_user_to_session('Assessor') }

      it { should be_forbidden }
    end
  end

  describe '#destroy' do
    let(:submission) { Submission.create({email_text: 'original'}) }
    let(:submission_id) { submission.id }

    subject(:response) { delete :destroy, {id: submission_id} }

    it_behaves_like 'a secured route'

    %w(Recruiter Administrator).each do |role|
      context "when user has role #{role}" do
        before { add_user_to_session(role) }

        context 'when destroying an existing submission' do
          it { should be_no_content }
          it 'should delete the submission' do
            response
            expect(Submission.count).to eq(0)
          end
        end

        context 'when destroying a submission that does not exist' do
          let(:submission_id) { submission.id + 1 }
          it { should be_not_found }
        end
      end
    end

    context 'when user is unauthorized' do
      before { add_user_to_session('Assessor') }
      it { should be_forbidden }
    end
  end
end
