require 'http_status'

class ApplicationController < ActionController::API
  rescue_from HttpStatus::ClientError, with: :client_error
  rescue_from CanCan::AccessDenied, with: :access_denied

  def client_error(error)
    render status: error.status, json: { error: error.message }
  end

  def access_denied
    response.headers['WWW-Authenticate'] = 'Bearer error="insufficient_scope"'
    render nothing: true, status: :forbidden
  end
end
