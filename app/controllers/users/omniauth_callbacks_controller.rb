class Users::OmniauthCallbacksController < ApplicationController
  def google
    auth_details = env['omniauth.auth']
    puts "Got omniauth.auth: #{auth_details}"
    info = auth_details['info']

    @user = {name: info['name'], email: info['email']}

    # Relevant fields:
    # auth_details['uid']
    # auth_details['info'] -- all
    # auth_details['credentials'] -- all

    # TODO: Check auth_details['extra']['raw_info']['hd'] == 'cyrusinnovation.com'

    state = URI::decode_www_form(params['state']).inject({}) {|r, (key,value)| r[key] = value;r}

    redirect_uri = state['redirect_uri']
    redirect_params = URI.encode_www_form(auth_details['credentials'])

    redirect_to "#{redirect_uri}?#{redirect_params}"
  end
end