require 'spec_helper'

describe AssessmentsController do
  let(:new_assessment_address1) { 'test.assessment1@example.com' }
  let(:new_assessment_address2) { 'test.assessment2@example.com' }

  before(:each) do
    Figaro.env.stub(:new_assessment_address => "#{new_assessment_address1}, #{new_assessment_address2}")
    Figaro.env.stub(:from_address => 'test.from@example.com')
  end

  describe '#create' do
    let(:submission) { Submission.new({email_text: 'A submission'}) }
    let(:assessor) { Assessor.new({name: 'Bob', email: 'bob@example.com'}) }
    let(:assessment) { Assessment.new({ submission: submission, assessor: assessor, score: 5, notes: 'Fantastic!' }) }
    let(:assessment_data) { {assessment: {submission_id: submission.id, assessor_id: assessor.id, score: 5, notes: 'Fantastic!'}} }

    before { 
      Assessment.stub(:create_from_json => assessment) 
      Notifications::Assessments.stub(:new_assessment)
    }

    subject(:response) { post :create, assessment_data }

    it_behaves_like 'a secured route'

    context 'with an active session' do
      before { add_user_to_session('Assessor') }

      it { should be_created }
      its(:body) { should be_json_eql(assessment_data[:assessment].to_json).at_path('assessment') }

      it 'should create an assessment' do
        response

        expect(Assessment).to have_received(:create_from_json)
      end

      it 'should send a new assessment email' do
        response

        expect(Notifications::Assessments).to have_received(:new_assessment)
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
    let(:submission1json) { {email_text: 'first', zipfile: '/zipfiles/original/missing.png', active: true, candidate_name: nil, candidate_email: nil, level_id: nil, language_id: nil} }
    let(:submission2json) { {email_text: 'second', zipfile: '/zipfiles/original/missing.png', active: true, candidate_name: nil, candidate_email: nil, level_id: nil, language_id: nil} }
    let(:assessor1json) { {email: 'bob@example.com', name: 'Bob'} }
    let(:assessor2json) { {email: 'alice@example.com', name: 'Alice'} }
    let(:assessment1json) { {submission_id: submission1.id, assessor_id: assessor1.id, score: 1, notes: 'Terrible!'} }
    let(:assessment2json) { {submission_id: submission2.id, assessor_id: assessor2.id, score: 5, notes: 'Amazing!'} }

    subject(:response) { get :index }

    it_behaves_like 'a secured route'

    context 'with an active session' do
      before { add_user_to_session('Assessor') }

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
