require 'spec_helper'

describe SubmissionsController do

  describe "POST" do
    it "saves the email text" do
      post :create, post: {"email_text"=> "a new code test."}
      expect(Submission.count).to eql(1)
    end

  end
end
