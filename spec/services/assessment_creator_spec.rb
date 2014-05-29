require 'spec_helper'

describe AssessmentCreator do
  describe '.create_assessment' do
    let(:assessment) { double(:submission => double()) }
    let(:assessment_json) { double() }

    before {
      Assessment.stub(:create_from_json).with(assessment_json).and_return(assessment)
      Notifications::Assessments.stub(:new_assessment)
      Policies::SubmissionClose.stub(:apply)
    }

    subject(:created_assessment) { AssessmentCreator.create_assessment(assessment_json) }

    it { should eql(assessment) }

    it 'should send notifications' do
      expect(Notifications::Assessments).to have_received(:new_assessment).with(created_assessment)
    end
  end
end
