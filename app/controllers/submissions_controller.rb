require 'net/http'

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

    created_submission = Submission.create!(email_text: submission['email_text'], zipfile: file, candidate: candidate, language: language)
    SubmissionMailer.new_submission(created_submission).deliver
    post_to_webhook(created_submission)
    render :json => created_submission,
           :status => :created
  end

  def post_to_webhook(submission)
    url = "#{Figaro.env.app_uri}/submissions/#{submission.id}"
    msg = "New Code Test Submission: <#{url}|Click to view>"
    payload = {
      username: 'code-test-bot',
      icon_emoji: ':scream:',
      attachments: [
        {
          fallback: msg,
          pretext: msg,
          color: '#0000D0',
          fields: [
            { title: 'Candidate Level', value: submission.level.text, short: false },
            { title: 'Language', value: submission.language.name, short: false }
          ]
        }
      ]
    }

    uri = URI(Figaro.env.slack_webhook)
    req = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
    req.body = payload.to_json
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == 'https')
    http.request(req)
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
