require 'spec_helper'

describe Session do
  it 'has a token and points to a User' do
    user = User.create({uid: '1234', name: 'Bob', email: 'bog@example.com'})
    session = Session.create({token: 'thisisatoken', token_expiry: Time.now.utc + 20.minutes, user: user})

    expect(Session.count).to eql(1)
    expect(Session.first.token).to eq(session.token)
    expect(Session.first.token_expiry).to be_within(1.second).of(session.token_expiry)
    expect(Session.first.user).to eq(user)
  end

  describe :expired? do
    it 'is expired if the current time is >= to the token expiry' do
      now = Time.now.utc

      expiry = now
      expect(session_with_expiry(expiry).expired?).to be_true

      expiry = now - 1.second
      expect(session_with_expiry(expiry).expired?).to be_true
    end

    it 'is not expired if the current time is < the token expiry' do
      now = Time.now.utc
      expiry = now + 1.second

      expect(session_with_expiry(expiry).expired?).to be_false
    end

    it 'is not expired if the expiry is 0' do
      expect(session_with_expiry(0).expired?).to be_false
    end

    private

    def session_with_expiry(expiry)
      Session.new({token_expiry: expiry})
    end
  end
end
