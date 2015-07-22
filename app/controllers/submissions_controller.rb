class SubmissionsController < UserAwareController
  def create
    authorize! :create, Submission
    submission = SubmissionCreator.create_submission(params[:submission])
    render :json => submission,
           :status => :created
  end

  def index
    authorize! :index, Submission
    render :json => Submission.all_with_average_score
  end

  def analytics
    authorize! :index, Submission
    render :json => Submission.all_with_average_score
  end

  def show
    authorize! :show, Submission
    render :json => Submission.find(params[:id])
  end

  def update
    authorize! :update, Submission
    submission_id = params[:id]
    submission = params[:submission]

    resumefile_name = submission[:resumefile_name]
    if resumefile_name
      resumefile_url = SubmissionFileUploader.upload(submission_id,
                                                     submission[:resumefile],
                                                     resumefile_name,
                                                     'resume')
    end


    submission_params = {email_text: submission[:email_text],
                         # agile: submission[:agile],
                         active: submission[:active],
                         candidate_name: submission[:candidate_name],
                         candidate_email: submission[:candidate_email],
                         github: submission[:github],
                         linkedin: submission[:linkedin]}
    if (resumefile_url)
      submission_params[:resumefile] = resumefile_url
    end

    render :json => Submission.update(submission_id, submission_params)
  end

  def destroy
    authorize! :destroy, Submission
    Submission.destroy(params[:id])
    render :nothing => true, status: :no_content
  end
end
