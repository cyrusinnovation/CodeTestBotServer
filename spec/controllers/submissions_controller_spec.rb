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
        let!(:submission) do
          Submission.create({email_text: 'test',
                             language: language,
                             candidate_name: 'Bob',
                             candidate_email: 'bob@example.com',
                             level: level,
                             github: 'github',
                             linkedin: 'linkedin'})
        end
        let(:expected) do
          [
            {
              email_text: 'test',
              zipfile: nil,
              resumefile: nil,
              average_score: nil,
              active: true,
              language_id: language.id,
              level_id: level.id,
              candidate_name: 'Bob',
              candidate_email: 'bob@example.com',
              source: nil,
              github: 'github',
              linkedin: 'linkedin'
            }
          ].to_json
        end

        subject(:body) { response.body }

        it { should be_json_eql(expected).at_path('submissions') }
        it { should have_json_type(Integer).at_path('submissions/0/id') }
        it { should be_json_eql([{name: language.name}].to_json).at_path('languages') }
        it { should be_json_eql([{text: level.text}].to_json).at_path('levels') }
      end

      context 'when the submission has assessments' do
        let!(:submission) { Submission.create({email_text: 'test', candidate_name: 'Bob', candidate_email: 'bob@example.com'}) }
        let!(:assessment1) { Assessment.create({submission: submission, score: 3, pros: 'Bad tests.', cons: 'Good OO design'}) }
        let!(:assessment2) { Assessment.create({submission: submission, score: 4, pros: 'Good OO design', cons: 'Bad tests.'}) }
        let(:expected) do
          [
            {
              email_text: 'test',
              zipfile: nil,
              resumefile: nil,
              average_score: '3.5',
              active: true,
              language_id: nil,
              level_id: nil,
              candidate_name: 'Bob',
              candidate_email: 'bob@example.com',
              source: nil,
              github: nil,
              linkedin: nil
            }
          ].to_json
        end
        subject(:body) { response.body }

        it { should be_json_eql(expected).at_path('submissions') }
      end

      context 'when there are multiple submissions they should be ordered by latest first' do
        let(:language) { Language.find_by_name('Java') }
        let(:level) { Level.find_by_text('Junior') }
        let!(:submission) { Submission.create({email_text: 'test1', language: language, candidate_name: 'Submission One', candidate_email: 'bob@example.com', level: level}) }
        let!(:submission2) { Submission.create({email_text: 'test2', language: language, candidate_name: 'Submission Two', candidate_email: 'bob@example.com', level: level}) }
        let(:expected) do
          [
            {
              email_text: 'test2',
              zipfile: nil,
              resumefile: nil,
              active: true,
              average_score: nil,
              language_id: language.id,
              level_id: level.id,
              candidate_name: 'Submission Two',
              candidate_email: 'bob@example.com',
              source: nil,
              github: nil,
              linkedin: nil
            },
            {
              email_text: 'test1',
              zipfile: nil,
              resumefile: nil,
              active: true,
              average_score: nil,
              language_id: language.id,
              level_id: level.id,
              candidate_name: 'Submission One',
              candidate_email: 'bob@example.com',
              source: nil,
              github: nil,
              linkedin: nil
            }
          ].to_json
        end

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
    let(:submission) { Submission.new({language: language}) }

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
      let(:expected) do
        {
          email_text: 'second',
          zipfile: nil,
          active: true,
          average_score: nil,
          language_id: nil,
          candidate_name: nil,
          candidate_email: nil,
          level_id: nil,
          source: nil,
          resumefile: nil,
          github: nil,
          linkedin: nil
        }.to_json
      end

      it { should be_ok }
      its(:body) { should be_json_eql(expected).at_path('submission') }
    end
  end

  describe '#update' do
    let(:submission) do
      Submission.create({email_text: 'original',
                         candidate_name: 'name',
                         candidate_email: 'email',
                         linkedin: 'linkedin',
                         github: 'github'})
    end

    let(:submission_id) { submission.id }
    let(:uploaded_file) { double('file contents') }

    subject(:response) do
      put :update, {id: submission_id,
                    submission: {email_text: 'updated',
                                 active: false,
                                 candidate_name: 'sandy',
                                 candidate_email: 'otheremail',
                                 github: 'othergithub',
                                 linkedin: 'otherlinkedin',
                                 resumefile_name: 'name.pdf',
                                 resumefile: uploaded_file}}
    end

    it_behaves_like 'a secured route'

    %w(Recruiter Administrator).each do |role|
      context "when user has role #{role}" do
        before do
          add_user_to_session(role)
          expect(SubmissionFileUploader).to receive(:upload).with(submission_id.to_s, uploaded_file.to_s, 'name.pdf', 'resume').and_return("public/uploads/submissions/#{submission_id}/resume-#{submission_id}-name.pdf")
        end

        context 'when updating an existing submission' do
          let(:expected) do
            {
              email_text: 'updated',
              average_score: nil,
              zipfile: nil,
              resumefile: nil,
              active: false,
              language_id: nil,
              candidate_name: 'sandy',
              candidate_email: 'otheremail',
              level_id: nil,
              source: nil,
              github: 'othergithub',
              linkedin: 'otherlinkedin',
              resumefile: "public/uploads/submissions/#{submission_id}/resume-#{submission_id}-name.pdf"
            }.to_json
          end

          it { should be_ok }
          its(:body) { should be_json_eql(expected).at_path('submission') }
          it 'should update the submission' do
            response
            sandys_submission = Submission.find(submission_id)
            expect(sandys_submission.email_text).to eq('updated')
            expect(sandys_submission.candidate_email).to eq('otheremail')
            expect(sandys_submission.candidate_name).to eq('sandy')
            expect(sandys_submission.github).to eq('othergithub')
            expect(sandys_submission.linkedin).to eq('otherlinkedin')
            expect(sandys_submission.resumefile).to eq("public/uploads/submissions/#{submission_id}/resume-#{submission_id}-name.pdf")
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
          it 'should delete submission assessments' do
            assessor = Assessor.create({name: 'Bob', email: 'bob@example.com'})
            Assessment.create({submission: submission, assessor: assessor, score: 5, notes: 'Fantastic!', pros: 'Bad tests.', cons: 'Good OO design'})
            expect(Assessment.count).to eq(1)
            response
            expect(Assessment.count).to eq(0)
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
