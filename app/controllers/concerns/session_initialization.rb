module SessionInitialization
  extend ActiveSupport::Concern

  def start_session_for_user_with_token(user_details, credentials)
    user = User.find_or_create_from_auth_hash(user_details)
    Session.create({token: credentials[:token], token_expiry: Time.at(credentials[:expires_at]), user: user})
  end
end