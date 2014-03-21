class Users::OmniauthCallbacksController < ApplicationController
  def google
    auth_details = env['omniauth.auth']
    info = auth_details['info']

    @user = {name: info['name'], email: info['email']}
  end
end