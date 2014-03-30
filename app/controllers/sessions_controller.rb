class SessionsController < ApplicationController
  def new
    unless params.include? 'redirect_uri'
      render status: 400, :json => { error: 'Missing required parameter redirect_uri.' }
      return
    end

    redirect_uri = URI::parse(params[:redirect_uri])

    unless [URI::HTTP, URI::HTTPS].include? redirect_uri.class
      render status: 400, :json => { error: 'Parameter redirect_uri must be a valid HTTP/HTTPS URI.' }
      return
    end

    auth_uri = URI::join(Figaro.env.base_uri, '/auth/google')
    auth_uri += "?state=#{URI::encode_www_form({ redirect_uri: redirect_uri })}"

    render :json => { auth_uri: auth_uri.to_s }
  end
end
