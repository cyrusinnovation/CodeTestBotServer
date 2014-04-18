require 'spec_helper'

describe SubmissionsController do
  let(:env) { fake_env }

  before {
    allow(env).to receive(:submissions_bucket).and_return('codetestbot-submissions-test')
    allow(env).to receive(:aws_access_key_id).and_return('fake_key')
    allow(env).to receive(:aws_secret_access_key).and_return('fake_secret')
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

      context 'when there are submissions' do
        let(:candidate) { Candidate.create({name: 'Bob'}) }
        let(:language) { Language.find_by_name('Java') }
        let!(:submission) { Submission.create({email_text: 'test', language: language, candidate: candidate}) }
        let(:expected) { [{email_text: 'test', zipfile: '/zipfiles/original/missing.png', language_id: language.id, candidate_id: candidate.id}].to_json }

        subject(:body) { response.body }

        it { should be_json_eql(expected).at_path('submissions') }
        it { should have_json_type(Integer).at_path('submissions/0/id') }
        it { should be_json_eql([{name: language.name}].to_json).at_path('languages') }
        it { should be_json_eql([{name: candidate.name, email: nil, level_id: nil}].to_json).at_path('candidates') }
      end
    end
  end

  describe '#create' do
    let(:file) { Tempfile.new('codetestbot-submission') }
    let(:email_text) { 'a new code test.' }
    let(:language) { Language.find_by_name('Java') }
    let(:candidate) { Candidate.create({name: 'Bob'}) }
    let(:params) { {submission: {email_text: email_text, zipfile: 'header,====', candidate_id: candidate.id, language_id: language.id}} }

    before {
      allow(Base64FileDecoder).to receive(:decode_to_file).and_return(file)
      FakeWeb.register_uri(:put, "https://codetestbot-submissions-test.s3.amazonaws.com/tmp/test/uploads/#{File.basename(file)}", :body => '')
    }

    subject(:response) { post :create, params }

    it_behaves_like 'a secured route'

    %w(Recruiter Administrator).each do |role|
      context "when user has role #{role}" do
        before { add_user_to_session(role) }

        it 'should create a submission' do
          expect(response).to be_created
          expect(Submission.count).to eql(1)
          expect(Submission.last.email_text).to eq email_text
          expect(Submission.last.zipfile.url).to include File.basename(file)
          expect(Submission.last.language.name).to eql(language.name)
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
      let(:expected) { {email_text: 'second', zipfile: '/zipfiles/original/missing.png', candidate_id: nil, language_id: nil}.to_json }

      it { should be_ok }
      its(:body) { should be_json_eql(expected).at_path('submission') }
    end
  end
end
