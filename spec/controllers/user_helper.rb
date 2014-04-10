module UserHelper

  def add_user_without_role_to_session
    token = '123456789'
    expiry = Time.now.utc + 20.minutes
    @user = User.create({ name: 'Bob', email: 'bob@example.com' })
    Session.create({token: token, token_expiry: expiry, user: @user})
    @request.headers['Authorization'] = "Bearer #{token}"
  end

  def add_user_to_session(role_name)
    token = '123456789'
    expiry = Time.now.utc + 20.minutes
    @role = Role.find_by_name(role_name)
    @user = User.create({ name: 'Bob', email: 'bob@example.com'})
    @user.roles.push(@role)
    Session.create({token: token, token_expiry: expiry, user: @user})
    @request.headers['Authorization'] = "Bearer #{token}"
  end
end