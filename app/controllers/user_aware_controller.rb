class UserAwareController < ApplicationController
  include CanCan::ControllerAdditions

  def get_session
    authorization = request.headers['Authorization']
    if not authorization
      raise 'No User found'
    end
    type, token = authorization.split(' ')
    session = Session.find_by_token token
    return session
  end

  def current_user
    session = get_session
    return session.user
  end
end
