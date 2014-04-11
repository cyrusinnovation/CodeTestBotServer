class OmniauthCallbacksController < ApplicationController
  include SessionInitialization

  def google
    auth_details = env['omniauth.auth']
    credentials = auth_details[:credentials]

    # Relevant fields:
    # auth_details['uid']
    # auth_details['info'] -- all
    # auth_details['credentials'] -- all

    # TODO: Check auth_details['extra']['raw_info']['hd'] == 'cyrusinnovation.com'

    start_session_for_user_with_token auth_details, credentials
    redirect_to build_redirect_uri_from_params(params, credentials)
  end

  def development_token
    unless Rails.env == 'development'
      return render :nothing => true, :status => 403
    end


    tomorrow = Time.now + 1.day
    expire_time = tomorrow.to_i
    auth_details = build_dev_auth_details(expire_time)
    credentials = auth_details[:credentials]

    start_session_for_user_with_token auth_details, credentials
    redirect_to build_redirect_uri_from_params(params, credentials)
  end

  private

  def build_redirect_uri_from_params(params, redirect_params)
    state = URI::decode_www_form(params['state']).inject({}) {|r, (key,value)| r[key] = value;r}

    redirect_uri = state['redirect_uri']
    redirect_params = URI.encode_www_form(redirect_params)

    "#{redirect_uri}?#{redirect_params}"
  end

  def build_dev_auth_details(expiry_time)
    {
        uid: 'dev',
        info: {
            name: 'Development User',
            email: 'dev@localhost'
        },
        credentials: {
            token: SecureRandom.hex(16),
            expires_at: expiry_time
        }
    }
  end
end