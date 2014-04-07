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

  def development_token
    unless Rails.env == 'development'
      return render :nothing => true, :status => 403
    end

    auth = {
        uid: 'dev',
        info: {
            name: 'Development User',
            email: 'dev@localhost'
        }
    }

    dev_user = User.find_or_create_from_auth_hash auth
    token = SecureRandom.hex(16)
    Session.create({ token: token, token_expiry: 0, user: dev_user })

    state = URI::decode_www_form(params['state']).inject({}) {|r, (key,value)| r[key] = value;r}

    redirect_uri = state['redirect_uri']
    redirect_params = URI.encode_www_form({
                                              token: token,
                                              expires: 0
                                          })

    redirect_to "#{redirect_uri}?#{redirect_params}"
  end
end