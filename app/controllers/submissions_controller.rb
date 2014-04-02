class SubmissionsController < ApplicationController
  def create
    submission = params[:submission]
    file = Base64FileDecoder.decode_to_file submission['zipfile']

    language = nil
    if submission.include? :language
      language = Language.find(submission[:language])
    end

    Submission.create(email_text: submission['emailText'], zipfile: file, language: language)
  end

  def index
    render :json => Submission.all
  end

  def show

  end
end
