class SubmissionsController < UserAwareController
  def create
    authorize! :create, Submission
    submission = params[:submission]
    file = Base64FileDecoder.decode_to_file submission['zipfile']
    candidate = Candidate.find(submission[:candidate_id])

    language = nil
    if submission.include? :language_id
      language = Language.find(submission[:language_id])
    end

    render :json => Submission.create(email_text: submission['email_text'], zipfile: file, candidate: candidate, language: language),
           :status => :created
  end

  def index
    authorize! :index, Submission
    render :json => Submission.all
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
