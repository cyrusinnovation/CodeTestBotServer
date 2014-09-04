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
    submission = params[:submission]

    render :json => Submission.update(params[:id], {email_text: submission[:email_text], active: submission[:active]})
  end

  def destroy
    authorize! :destroy, Submission
    Submission.destroy(params[:id])
    render :nothing => true, status: :no_content
  end
end
