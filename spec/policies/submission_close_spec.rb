require 'spec_helper'

describe Policies::SubmissionClose do
  let(:submission) { Submission.new }
  before {
    submission.stub(:close)
    Notifications::Submissions.stub(:closed_by_assessments)
  }

  context 'when submission has 3 assessments' do
    before { submission.assessments.stub(:length => 3) }

    it 'should close the submission' do
      Policies::SubmissionClose.apply(submission)

      expect(submission).to have_received(:close)
    end

    it 'should trigger closed notification' do
      Policies::SubmissionClose.apply(submission)

      expect(Notifications::Submissions).to have_received(:closed_by_assessments).with(submission)
    end
  end

  context 'when submission has < 3 assessments' do
    before { submission.assessments.stub(:length => 2) }

    it 'should do nothing' do
      Policies::SubmissionClose.apply(submission)

      expect(submission).not_to have_received(:close)
    end
  end
end
