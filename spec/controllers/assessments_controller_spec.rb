require 'spec_helper'

describe AssessmentsController do
  include UserHelper

  describe '#create' do
    let(:submission) { Submission.create({email_text: 'A submission'}) }
    let(:assessor) { Assessor.create({name: 'Bob', email: 'bob@example.com'}) }
    let(:assessment_data) { {assessment: {submission_id: submission.id, assessor_id: assessor.id, score: 5, notes: 'Fantastic!'}} }

    subject(:response) { post :create, assessment_data }

    it_behaves_like 'a secured route'

    context 'with an active session' do
      before { add_user_without_role_to_session }

      it { should be_created }
      its(:body) { should be_json_eql(assessment_data[:assessment].to_json).at_path('assessment') }

      it 'should create an assessment' do
        response
        expect(Assessment.count).to eql(1)
        expect(Assessment.first.submission).to eql(submission)
        expect(Assessment.first.assessor).to eql(assessor)
        expect(Assessment.first.score).to eql(5)
        expect(Assessment.first.notes).to eql('Fantastic!')
      end
    end
  end

  describe '#index' do
    let!(:submission1) { Submission.create({email_text: 'first'}) }
    let!(:submission2) { Submission.create({email_text: 'second'}) }
    let!(:assessor1) { Assessor.create({name: 'Bob', email: 'bob@example.com'}) }
    let!(:assessor2) { Assessor.create({name: 'Alice', email: 'alice@example.com'}) }
    let!(:assessment1) { Assessment.create({submission: submission1, assessor: assessor1, score: 1, notes: 'Terrible!'}) }
    let!(:assessment2) { Assessment.create({submission: submission2, assessor: assessor2, score: 5, notes: 'Amazing!'}) }
    let(:submission1json) { {email_text: 'first', zipfile: '/zipfiles/original/missing.png', candidate_id: nil, language_id: nil} }
    let(:submission2json) { {email_text: 'second', zipfile: '/zipfiles/original/missing.png', candidate_id: nil, language_id: nil} }
    let(:assessor1json) { {email: 'bob@example.com', name: 'Bob'} }
    let(:assessor2json) { {email: 'alice@example.com', name: 'Alice'} }
    let(:assessment1json) { {submission_id: submission1.id, assessor_id: assessor1.id, score: 1, notes: 'Terrible!'} }
    let(:assessment2json) { {submission_id: submission2.id, assessor_id: assessor2.id, score: 5, notes: 'Amazing!'} }

    subject(:response) { get :index }

    it_behaves_like 'a secured route'

    context 'with an active session' do
      before { add_user_without_role_to_session }

      context 'with no filter' do
        it { should be_ok }
        its(:body) { should be_json_eql([assessment1json, assessment2json].to_json).at_path('assessments') }
        its(:body) { should be_json_eql([submission1json, submission2json].to_json).at_path('submissions') }
        its(:body) { should be_json_eql([assessor1json, assessor2json].to_json).at_path('assessors') }
      end

      context 'with a submission_id filter' do
        subject { get :index, submission_id: submission1.id }

        it { should be_ok }
        its(:body) { should be_json_eql([assessment1json].to_json).at_path('assessments') }
      end

      context 'with an assessor_id filter' do
        subject { get :index, assessor_id: assessor2.id }

        it { should be_ok }
        its(:body) { should be_json_eql([assessment2json].to_json).at_path('assessments') }
      end
    end
  end
end
