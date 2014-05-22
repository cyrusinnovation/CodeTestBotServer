require 'spec_helper'

describe AssessmentsController do
  let(:new_assessment_address1) { 'test.assessment1@example.com' }
  let(:new_assessment_address2) { 'test.assessment2@example.com' }

  before(:each) do
    Figaro.env.stub(:new_assessment_address => "#{new_assessment_address1}, #{new_assessment_address2}")
    Figaro.env.stub(:from_address => 'test.from@example.com')
  end

  describe '#create' do
    let(:candidate) { Candidate.create({name: 'Test Candidate'})}
    let(:submission) { Submission.create({email_text: 'A submission', candidate: candidate}) }
    let(:assessor) { Assessor.create({name: 'Bob', email: 'bob@example.com'}) }
    let(:assessment_data) { {assessment: {submission_id: submission.id, assessor_id: assessor.id, score: 5, notes: 'Fantastic!'}} }

    subject(:response) { post :create, assessment_data }

    it_behaves_like 'a secured route'

    context 'with an active session' do
      before { add_user_to_session('Assessor') }

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

      it 'should send a new assessment email' do
        expect(response).to be_created
        email = ActionMailer::Base.deliveries.last

        expect(email.to).to have(2).elements
        expect(email.to).to include(new_assessment_address1)
        expect(email.to).to include(new_assessment_address2)
        expect(email.subject).to eq("[CTB] Assessment for #{candidate.name}")
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
    let(:submission1json) { {email_text: 'first', zipfile: '/zipfiles/original/missing.png', active: true, candidate_id: nil, language_id: nil} }
    let(:submission2json) { {email_text: 'second', zipfile: '/zipfiles/original/missing.png', active: true, candidate_id: nil, language_id: nil} }
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


  describe '#update' do
    let(:candidate) { Candidate.create({name: 'Test Candidate'})}
    let(:submission) { Submission.create({email_text: 'A submission', candidate: candidate}) }
    let(:assessor) { Assessor.create({name: 'Bob', email: 'bob@example.com'}) }
    let(:another_assessor) { Assessor.create({name: 'Kate', email: 'kate@example.com'}) }
    let(:assessment) { Assessment.create({submission: submission, assessor: assessor, score: 5, notes: 'Amazing!'}) }
    let(:assessment_data) { {id: assessment.id, assessment: {submission_id: submission.id, assessor_id: assessor.id, score: 4, notes: 'Actually just good, not amazing!'}} }

    subject(:response) { post :update, assessment_data }

    it_behaves_like 'a secured route'

    context 'with the assessor signed in who created the assessment' do
      before { add_existing_user_to_session('Assessor', assessor.id) }

      its(:body) { should be_json_eql(assessment_data[:assessment].to_json).at_path('assessment') }

      it 'should have updated the asessment' do
        response
        expect(Assessment.count).to eql(1)
        expect(Assessment.first.submission).to eql(submission)
        expect(Assessment.first.assessor).to eql(assessor)
        expect(Assessment.first.score).to eql(4)
        expect(Assessment.first.notes).to eql('Actually just good, not amazing!')
      end
    end

    context 'with another assessor signed in' do
      before { add_existing_user_to_session('Assessor', another_assessor.id) }
      it {should be_forbidden}
    end


  end
end
