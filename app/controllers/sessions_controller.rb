class SessionsController < SecuredController
  include ParameterValidation
  include URIValidation
  skip_before_action :check_authorization, only: [:new]

  def new
    validate_parameters_present('redirect_uri')

    redirect_uri = URI::parse(params[:redirect_uri])
    validate_protocol(redirect_uri)

    auth_uri = URI::join(Figaro.env.base_uri, path)
    auth_uri += "?state=#{URI::encode_www_form({ redirect_uri: redirect_uri })}"

    render :json => { auth_uri: auth_uri.to_s }
  end

  def show
    render :json => @session
  end

  private

  def validate_protocol(uri)
    message = 'Parameter redirect_uri must be a valid HTTP/HTTPS URI.'
    raise HttpStatus::BadRequest.new message unless matches_protocol?(uri, :http, :https)
  end

  def path
    use_dev_token? ? '/auth/development_token' : '/auth/google'
  end

  def use_dev_token?
    (Figaro.env.respond_to?(:use_dev_token) && Figaro.env.use_dev_token == 'true')
  end
end
