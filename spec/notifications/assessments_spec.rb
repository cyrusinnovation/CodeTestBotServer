require 'spec_helper'

describe Notifications::Assessments do
  describe '.new_assessment' do
    let(:mailer) { double(:deliver => nil) }
    let(:assessment) { double() }

    before {
      AssessmentMailer.stub(:new_assessment => mailer)
    }

    it 'should call the new_assessment mailer' do
      Notifications::Assessments.new_assessment(assessment) 

      expect(mailer).to have_received(:deliver)
    end
  end
end
