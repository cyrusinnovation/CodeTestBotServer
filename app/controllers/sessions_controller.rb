class SessionsController < ApplicationController
  include ParameterValidation
  include URIValidation

  def new
    validate_parameters_present('redirect_uri')

    redirect_uri = URI::parse(params[:redirect_uri])
    validate_protocol(redirect_uri)

    auth_uri = URI::join(Figaro.env.base_uri, '/auth/google')
    auth_uri += "?state=#{URI::encode_www_form({ redirect_uri: redirect_uri })}"

    render :json => { auth_uri: auth_uri.to_s }
  end

  private

  def validate_protocol(uri)
    message = 'Parameter redirect_uri must be a valid HTTP/HTTPS URI.'
    raise HttpStatus::BadRequest.new message unless matches_protocol?(uri, :http, :https)
  end
end
