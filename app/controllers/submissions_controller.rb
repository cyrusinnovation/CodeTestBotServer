class SubmissionsController < ApplicationController
  def create
    file = Base64FileDecoder.decode_to_file params['submission']['zipfile']

    Submission.create(email_text: params['submission']['emailText'], zipfile: file)
  end

  def index

  end

  def show

  end
end
