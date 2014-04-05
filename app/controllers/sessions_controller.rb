class SessionsController < ApplicationController
  include ParameterValidation
  include URIValidation

  def new
    validate_parameters_present('redirect_uri')

    redirect_uri = URI::parse(params[:redirect_uri])
    validate_protocol(redirect_uri)

    if Figaro.env.respond_to? :use_dev_token
      path = '/auth/development_token'
    else
      path = '/auth/google'
    end
    auth_uri = URI::join(Figaro.env.base_uri, path)
    auth_uri += "?state=#{URI::encode_www_form({ redirect_uri: redirect_uri })}"

    render :json => { auth_uri: auth_uri.to_s }
  end

  def show
    authorization = request.headers['Authorization']
    if authorization == nil
      return render :nothing => true, :status => 403
    end

    type, token = authorization.split(' ')

    session = Session.find_by_token token
    if session == nil || session.expired?
      return render :nothing => true, :status => 403
    end

    render :json => session
  end

  private

  def validate_protocol(uri)
    message = 'Parameter redirect_uri must be a valid HTTP/HTTPS URI.'
    raise HttpStatus::BadRequest.new message unless matches_protocol?(uri, :http, :https)
  end
end
