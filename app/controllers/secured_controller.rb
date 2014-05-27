class SecuredController < ApplicationController
  before_action :check_authorization_header

  private

  # why fake user? because otherwise you can't access the json for the server directly. It's useful to see the actual json when there are errors.
  def get_fake_user
    dev_user = User.find_by_uid('dev')
    if dev_user == nil
      dev_user = User.create({ name: 'Development User', email: 'dev@localhost', uid: 'dev' })
    end
    admin_role = Role.find_by_name("Administrator")
    if not dev_user.role == admin_role
      dev_user.role = admin_role
      dev_user.save
    end
    return dev_user
  end

  def get_fake_session
    token = '123456789'
    expiry = Time.now.utc + 20.minutes
    request.headers['Authorization'] = "Bearer #{token}"
    user = get_fake_user
    @session = Session.create({token: token, token_expiry: expiry, user: user})
  end

  def check_authorization_header
    authorization = request.headers['Authorization']
    if Figaro.env.use_dev_token == 'true' and authorization == nil
      return get_fake_session
    else
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
      end
    end
  end
end