class Users::OmniauthCallbacksController < ApplicationController
  def google
    auth_details = env['omniauth.auth']

    # Relevant fields:
    # auth_details['uid']
    # auth_details['info'] -- all
    # auth_details['credentials'] -- all

    # TODO: Check auth_details['extra']['raw_info']['hd'] == 'cyrusinnovation.com'

    User.find_or_create_from_auth_hash(auth_details)

    state = URI::decode_www_form(params['state']).inject({}) {|r, (key,value)| r[key] = value;r}

    redirect_uri = state['redirect_uri']
    redirect_params = URI.encode_www_form(auth_details['credentials'])

    redirect_to "#{redirect_uri}?#{redirect_params}"
  end
end