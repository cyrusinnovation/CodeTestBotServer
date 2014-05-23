require 'spec_helper'

describe Notifications::Submissions do
  describe '.new_submission' do
    let(:mailer) { double(:deliver => nil) }
    let(:submission) { double() }

    before { 
      SubmissionMailer.stub(:new_submission => mailer) 
      Notifications::Submissions::WebHooks.stub(:new_submission)
    }

    it 'should call the new_submission mailer' do
      Notifications::Submissions.new_submission(submission)

      expect(mailer).to have_received(:deliver)
    end
    
    it 'should call the new_submission WebHook' do
      Notifications::Submissions.new_submission(submission)

      expect(Notifications::Submissions::WebHooks).to have_received(:new_submission)
    end
  end

  describe '.closed_by_assessments' do
    let(:mailer) { double(:deliver => nil) }
    let(:submission) { double() }

    before {
      SubmissionMailer.stub(:closed_by_assessments => mailer)
    }

    it 'should call the closed_by_assessments mailer' do
      Notifications::Submissions.closed_by_assessments(submission)

      expect(mailer).to have_received(:deliver)
    end
  end
end
