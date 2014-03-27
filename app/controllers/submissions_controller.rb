class SubmissionsController < ApplicationController
  def create
    Submission.create(email_text: params['email_text'], zipfile: params['zipfile'])
  end

  def index

  end

  def show

  end
end
