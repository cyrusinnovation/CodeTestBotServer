class AnalyticsController < UserAwareController
  def index
    authorize! :index, Submission
    render :json => Submission.all_with_average_score
  end
end
