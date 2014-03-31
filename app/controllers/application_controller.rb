require 'http_status'

class ApplicationController < ActionController::API
  rescue_from HttpStatus::ClientError, with: :client_error

  def client_error(error)
    render status: error.status, json: { error: error.message }
  end
end
