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
end
