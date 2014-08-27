require 'spec_helper'

describe Policies::SubmissionClose do
  let(:submission) { Submission.new }
  before {
    submission.stub(:close)
    Notifications::Submissions.stub(:closed_by_assessments)
  }

  context 'when submission has 3 assessments' do
    before { submission.assessments.stub(:length => 3) }

    context 'when all assessments are at least an hour old' do
      context 'with a published flag' do
        before {
          assessment = double(:age => 1.hour, :published => true)
          submission.stub(:assessments => [assessment, assessment, assessment])
        }

        it 'should close the submission' do
          Policies::SubmissionClose.apply(submission)

          expect(submission).to have_received(:close)
        end

        it 'should trigger closed notification' do
          Policies::SubmissionClose.apply(submission)

          expect(Notifications::Submissions).to have_received(:closed_by_assessments).with(submission)
        end
      end

      context 'without a published flag' do
        before {
          assessment = double(:age => 1.hour, :published => true)
          submission.stub(:assessments => [assessment, assessment, double(:age => 1.hour, :published => false)])
        }

        it 'should do nothing' do
          Policies::SubmissionClose.apply(submission)

          expect(submission).not_to have_received(:close)
        end
      end
    end

    context 'when at least one assessment is less than an hour old' do
      before {
        old_enough = double(:age => 1.hour, :published => true)
        too_young = double(:age => (1.hour - 1.second), :published => true)

        submission.stub(:assessments => [old_enough, too_young, old_enough])
      }

      it 'should do nothing' do
        Policies::SubmissionClose.apply(submission)

        expect(submission).not_to have_received(:close)
      end
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
