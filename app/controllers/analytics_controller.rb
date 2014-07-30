class AnalyticsController < UserAwareController
  def index
    authorize! :index, Submission
    render :json => Submission.all.order(updated_at: :desc)
  end
end
