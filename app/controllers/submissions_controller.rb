class SubmissionsController < ApplicationController
  def create
    submission = params[:submission]
    file = Base64FileDecoder.decode_to_file submission['zipfile']
    candidate = Candidate.find(submission[:candidate_id])

    language = nil
    if submission.include? :language_id
      language = Language.find(submission[:language_id])
    end

    Submission.create(email_text: submission['email_text'], zipfile: file, candidate: candidate, language: language)
  end

  def index
    render :json => Submission.all
  end

  def show

  end
end
