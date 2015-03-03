class ExternalSubmissionsController < ApplicationController
  def create
    submission = SubmissionCreator.create_submission(params[:submission])
    render :json => submission,
           :status => :created
  end
end