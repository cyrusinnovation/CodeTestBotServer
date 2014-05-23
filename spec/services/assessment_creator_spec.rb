require 'spec_helper'

describe AssessmentCreator do
  describe '.create_assessment' do
    let(:assessment) { double(:submission => double(:close => nil, :assessments => [])) }
    let(:assessment_json) { double() }

    before {
      Assessment.stub(:create_from_json).with(assessment_json).and_return(assessment)
      Notifications::Assessments.stub(:new_assessment)
    }

    subject(:created_assessment) { AssessmentCreator.create_assessment(assessment_json) }

    it { should eql(assessment) }

    it 'should send notifications' do
      expect(Notifications::Assessments).to have_received(:new_assessment).with(created_assessment)
    end

    it 'should check # of assessment' do
      assessment.submission.assessments.stub(:length => 3)

      AssessmentCreator.create_assessment(assessment_json)

      expect(assessment.submission).to have_received(:close)
    end
  end
end
