class SubmissionsController < ApplicationController
  def create
    Submission.create(email_text: params['emailText'], zipfile: params['zipfile'])
  end

  def index

  end

  def show

  end
end
