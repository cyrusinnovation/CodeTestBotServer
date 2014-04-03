class Users::OmniauthCallbacksController < ApplicationController
  def google
    auth_details = env['omniauth.auth']

    # Relevant fields:
    # auth_details['uid']
    # auth_details['info'] -- all
    # auth_details['credentials'] -- all

    # TODO: Check auth_details['extra']['raw_info']['hd'] == 'cyrusinnovation.com'

    user = User.find_or_create_from_auth_hash(auth_details)
    Session.create({token: auth_details['credentials']['token'], token_expiry: Time.at(auth_details['credentials']['expires_at']), user: user})

    state = URI::decode_www_form(params['state']).inject({}) {|r, (key,value)| r[key] = value;r}

    redirect_uri = state['redirect_uri']
    redirect_params = URI.encode_www_form(auth_details['credentials'])

    redirect_to "#{redirect_uri}?#{redirect_params}"
  end
end