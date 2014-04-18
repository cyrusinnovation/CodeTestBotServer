class UserAwareController < SecuredController
  include CanCan::ControllerAdditions

  def current_user
    @session.user
  end
end
