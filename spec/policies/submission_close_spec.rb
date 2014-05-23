require 'spec_helper'

describe Policies::SubmissionClose do
  let(:submission) { Submission.new }
  before { submission.stub(:close) }

  context 'when submission has 3 assessments' do
    before { submission.assessments.stub(:length => 3) }

    it 'should close the submission' do
      Policies::SubmissionClose.apply(submission)

      expect(submission).to have_received(:close)
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
