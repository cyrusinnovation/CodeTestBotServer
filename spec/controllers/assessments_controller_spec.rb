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
    let(:assessment_data) { {assessment: {submission_id: submission.id, assessor_id: assessor.id, score: 5, notes: 'Fantastic!', published: true}.to_json} }

    before { 
      AssessmentCreator.stub(:create_assessment).with(assessment_data[:assessment]).and_return(assessment)
    }

    subject(:response) { post :create, assessment_data }

    it_behaves_like 'a secured route'

    context 'with an active session' do
      before { add_user_to_session('Assessor') }

      it { should be_created }
      its(:body) { should be_json_eql(assessment_data[:assessment]).at_path('assessment') }

      it 'should call create assessment service' do
        response

        expect(AssessmentCreator).to have_received(:create_assessment).with(assessment_data[:assessment])
      end

      context 'when assessment create raises ExistingAssessmentError' do
        before { AssessmentCreator.stub(:create_assessment).and_raise(Assessment::ExistingAssessmentError) }

        it { should be_forbidden }
        its(:body) { should be_json_eql(['You can only create one assessment per submission.']).at_path('errors') }
      end
    end
  end

  describe '#index' do
    let!(:submission1) { Submission.create({email_text: 'first'}) }
    let!(:submission2) { Submission.create({email_text: 'second'}) }
    let!(:submission3) { Submission.create({email_text: 'third'}) }
    let!(:assessor1) { Assessor.create({name: 'Bob', email: 'bob@example.com'}) }
    let!(:assessor2) { Assessor.create({name: 'Alice', email: 'alice@example.com'}) }
    let!(:assessment1) { Assessment.create({submission: submission1, assessor: assessor1, score: 1, notes: 'Terrible!'}) }
    let!(:assessment2) { Assessment.create({submission: submission2, assessor: assessor2, score: 5, notes: 'Amazing!'}) }
    let!(:assessment3) { Assessment.create({submission: submission3, assessor: assessor2, score: 5, notes: 'Commentary!', published: false}) }
    let(:submission1json) { {email_text: 'first', zipfile: nil, average_score: nil, active: true, candidate_name: nil, candidate_email: nil, level_id: nil, language_id: nil} }
    let(:submission2json) { {email_text: 'second', zipfile: nil, average_score: nil, active: true, candidate_name: nil, candidate_email: nil, level_id: nil, language_id: nil} }
    let(:submission3json) { {email_text: 'third', zipfile: nil, average_score: nil, active: true, candidate_name: nil, candidate_email: nil, level_id: nil, language_id: nil} }
    let(:assessor1json) { {email: 'bob@example.com', name: 'Bob'} }
    let(:assessor2json) { {email: 'alice@example.com', name: 'Alice'} }
    let(:assessment1json) { {submission_id: submission1.id, assessor_id: assessor1.id, score: 1, notes: 'Terrible!', published: true} }
    let(:assessment2json) { {submission_id: submission2.id, assessor_id: assessor2.id, score: 5, notes: 'Amazing!', published: true} }
    let(:assessment3json) { {submission_id: submission3.id, assessor_id: assessor2.id, score: 5, notes: 'Commentary!', published: false} }

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

      context 'with include_unpublished true' do
        subject { get :index, include_unpublished: true }

        it { should be_ok }
        its(:body) { should be_json_eql([assessment1json, assessment2json, assessment3json].to_json).at_path('assessments') }
        its(:body) { should be_json_eql([submission1json, submission2json, submission3json].to_json).at_path('submissions') }
      end
    end
  end


  describe '#update' do
    let(:submission) { Submission.create({email_text: 'A submission', candidate_name: 'Test Candidate'}) }
    let(:assessor) { Assessor.create({name: 'Bob', email: 'bob@example.com'}) }
    let(:another_assessor) { Assessor.create({name: 'Kate', email: 'kate@example.com'}) }
    let(:assessment) { Assessment.create({submission: submission, assessor: assessor, score: 5, notes: 'Amazing!', published: false}) }
    let(:assessment_data) { {id: assessment.id, assessment: {submission_id: submission.id, assessor_id: assessor.id, score: 4, notes: 'Actually just good, not amazing!', published: true}.to_json}.with_indifferent_access }

    subject(:response) { post :update, assessment_data }

    it_behaves_like 'a secured route'

    context 'with the assessor signed in who created the assessment' do
      before {
        add_existing_user_to_session('Assessor', assessor.id)
        AssessmentCreator.stub(:update_assessment).with(assessment, assessment_data[:assessment]).and_return(Assessment.new({submission: submission, assessor: assessor, score: 4, notes: 'Actually just good, not amazing!', published: true}))
      }

      its(:body) { should be_json_eql(assessment_data[:assessment]).at_path('assessment') }

      it 'should call the update assessment service' do
        response

        expect(AssessmentCreator).to have_received(:update_assessment).with(assessment, assessment_data[:assessment])
      end
    end

    context 'with another assessor signed in' do
      before { add_existing_user_to_session('Assessor', another_assessor.id) }
      it {should be_forbidden}
    end
  end
end
