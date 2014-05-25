class UserAwareController < SecuredController
  include CanCan::ControllerAdditions


  def get_fake_user
    dev_user = User.find_by_uid('dev')
    if dev_user == nil
      dev_user = User.create({ name: 'Development User', email: 'dev@localhost', uid: 'dev' })
    end
    admin_role = Role.find_by_name("Administrator")
    if not dev_user.role == admin_role
      dev_user.role = admin_role
    end
    return dev_user
  end


  def current_user
    if Figaro.env.respond_to?(:use_dev_token) && Figaro.env.use_dev_token == 'true'
      return get_fake_user
    else
      @session.user
    end
  end
end
