require 'spec_helper'

describe User do
  describe :find_or_create_by_auth_hash do
    before(:each) do
      @auth_details = {
          uid: '123456789',
          info: {
              name: 'Bob',
              email: 'bob@example.com'
          },
          credentials: {
              token: 'areallylongtokenforrealz',
              expires_at: 9999,
              expires: true
          }
      }
    end

    it 'should find an existing user by UID and update its token' do
      User.create({uid: @auth_details[:uid], name: 'Alice', email: 'alice@example.com', token: 'blank!' })

      user = User.find_or_create_from_auth_hash @auth_details

      expect(User.count).to eql(1)
      expect(user.uid).to eql(@auth_details[:uid])
      expect(user.name).to eql('Alice')
      expect(user.email).to eql('alice@example.com')
      expect(user.token).to eql(@auth_details[:credentials][:token])
    end

    it 'should create a user from auth hash if it does not exist' do
      user = User.find_or_create_from_auth_hash @auth_details

      expect(User.count).to eql(1)
      expect(user.uid).to eql(@auth_details[:uid])
      expect(user.name).to eql(@auth_details[:info][:name])
      expect(user.email).to eql(@auth_details[:info][:email])
      expect(user.token).to eql(@auth_details[:credentials][:token])
    end
  end
end
