class SecuredController < ApplicationController
  before_action :check_authorization

  private

  def check_authorization
    authorization = request.headers['Authorization']
    if authorization == nil
      response.headers['WWW-Authenticate'] = 'Bearer'
      return render :nothing => true, :status => 401
    end

    type, token = authorization.split(' ')
    unless type == 'Bearer'
      response.headers['WWW-Authenticate'] = 'Bearer error="invalid_request"'
      return render :nothing => true, :status => 400
    end

    @session = Session.find_by_token token
    if @session == nil || @session.expired?
      response.headers['WWW-Authenticate'] = 'Bearer error="invalid_token", error_description="Access Token Expired"'
      return render :nothing => true, :status => 401
    end
  end
end