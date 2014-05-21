class SecuredController < ApplicationController
  before_action :check_authorization_header

  private

  def check_authorization_header
    if not Figaro.env.respond_to?(:use_dev_token) or not Figaro.env.use_dev_token == 'true'
      authorization = request.headers['Authorization']
      if authorization == nil
        response.headers['WWW-Authenticate'] = 'Bearer'
        return render :nothing => true, :status => :unauthorized
      end

      type, token = authorization.split(' ')
      unless type == 'Bearer'
        response.headers['WWW-Authenticate'] = 'Bearer error="invalid_request"'
        return render :nothing => true, :status => :bad_request
      end

      @session = Session.find_by_token token
      if @session == nil || @session.expired?
        response.headers['WWW-Authenticate'] = 'Bearer error="invalid_token", error_description="Access Token Expired"'
        return render :nothing => true, :status => :unauthorized
      else
        @session.reset_token_expiry!
        @session.save!
      end
    end
  end
end