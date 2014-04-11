class UserAwareController < ApplicationController
  include CanCan::ControllerAdditions

  def get_real_user
    authorization = request.headers['Authorization']
    type, token = authorization.split(' ')
    session = Session.find_by_token token
    return session.user
  end

  def get_fake_user
    dev_user = User.find_by_uid('dev')
    if dev_user == nil
      dev_user = User.create({ name: 'Development User', email: 'dev@localhost', uid: 'dev' })
    end
    admin_role = Role.find_by_name("Administrator")
    if not dev_user.roles.include? admin_role
      dev_user.roles.push(admin_role)
    end
    return dev_user
  end

  def current_user
    authorization = request.headers['Authorization']
     if not authorization
       if Figaro.env.respond_to?(:use_dev_token) && Figaro.env.use_dev_token == 'true'
         return get_fake_user
       else
         raise 'No User found'
       end
     end
    return get_real_user
  end

end
