module CodeTestBotServer
  module Helpers
    def add_user_to_session(role_name)
      token = '123456789'
      expiry = Time.now.utc + 20.minutes
      @role = Role.find_by_name(role_name)
      @user = User.create({name: 'Bob', email: 'bob@example.com'})
      @user.roles.push(@role)
      Session.create({token: token, token_expiry: expiry, user: @user})
      @request.headers['Authorization'] = "Bearer #{token}"
    end

    def add_existing_user_to_session(role_name, user_id)
      token = '123456789'
      expiry = Time.now.utc + 20.minutes
      @role = Role.find_by_name(role_name)
      @user = User.find(user_id)
      @user.roles.push(@role)
      Session.create({token: token, token_expiry: expiry, user: @user})
      @request.headers['Authorization'] = "Bearer #{token}"
    end

  end
end