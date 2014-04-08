require 'spec_helper'

describe SessionInitialization do

  class Dummy
    include SessionInitialization
  end

  before(:each) do
    @user_details = {
        uid: 'dev',
        info: {
            name: 'Development User',
            email: 'dev@localhost'
        }
    }
    @credentials = {token: '1234', expires_at: 0}

    @user = User.find_or_create_from_auth_hash @user_details
  end

  it 'finds or creates a user from the user details hash' do
    expect(User).to receive(:find_or_create_from_auth_hash).with(@user_details)

    Dummy.new.start_session_for_user_with_token @user_details, @credentials
  end

  it 'creates a session from the user and token details from the credentials hash' do
    Dummy.new.start_session_for_user_with_token @user_details, @credentials

    expect(Session.count).to eq(1)
    session = Session.first
    expect(session.user).to eq(@user)
    expect(session.token).to eq(@credentials[:token])
    expect(session.token_expiry).to eq(Time.at(@credentials[:expires_at]))
  end
end