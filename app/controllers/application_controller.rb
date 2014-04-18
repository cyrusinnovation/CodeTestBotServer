require 'http_status'

class ApplicationController < ActionController::API
  rescue_from HttpStatus::ClientError, with: :client_error
  rescue_from CanCan::AccessDenied, with: :access_denied
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def client_error(error)
    json_error(error.status, error.message)
  end

  def access_denied
    response.headers['WWW-Authenticate'] = 'Bearer error="insufficient_scope"'
    render nothing: true, status: :forbidden
  end

  def not_found(error)
    json_error(:not_found, error.message)
  end

  private

  def json_error(status, message)
    render status: status, json: { error: message }
  end
end
