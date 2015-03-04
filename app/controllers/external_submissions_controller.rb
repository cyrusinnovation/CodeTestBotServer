class ExternalSubmissionsController < ApplicationController
  def create
    submission = SubmissionCreator.create_submission(params[:extsubmission])
    render :json => submission,
           :status => :created
  end
end