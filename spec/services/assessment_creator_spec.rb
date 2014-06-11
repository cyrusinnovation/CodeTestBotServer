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
  end

  describe '.update_assessment' do
    let(:assessment) { double(:submission => double(), :published => false) }
    let(:assessment_json) { {} }

    before {
      assessment.stub(:update_from_json).with(assessment_json).and_return(assessment)
      Notifications::Assessments.stub(:new_assessment)
    }

    subject!(:updated_assessment) { AssessmentCreator.update_assessment(assessment, assessment_json) }

    it { should eql(assessment) }

    it 'delegates to update_assessment on the model' do
      expect(assessment).to have_received(:update_from_json).with(assessment_json)
    end

    context 'when published flag is true' do
      before { assessment_json[:published] = true }

      context 'with an unpublished assessment' do
        before { assessment.stub(:published => false) }

        it 'should send new assessment notification' do
          AssessmentCreator.update_assessment(assessment, assessment_json)

          expect(Notifications::Assessments).to have_received(:new_assessment).with(assessment)
        end
      end

      context 'with a published assessment' do
        before { assessment.stub(:published => true) }

        it 'should not send a notification' do
          AssessmentCreator.update_assessment(assessment, assessment_json)

          expect(Notifications::Assessments).to_not have_received(:new_assessment)
        end
      end
    end

    context 'when published flag is false' do
      before { assessment_json[:published] = false }

      it 'should not send notifications' do
        AssessmentCreator.update_assessment(assessment, assessment_json)

        expect(Notifications::Assessments).to_not have_received(:new_assessment)
      end
    end
  end
end
