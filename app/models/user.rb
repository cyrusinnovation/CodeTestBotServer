class User < ActiveRecord::Base
  def self.find_or_create_from_auth_hash(auth_details)
    user = User.find_by_uid(auth_details[:uid])
    if user == nil
      user = create_from_auth_hash auth_details
    else
      user = User.update(user.id, :token => auth_details[:credentials][:token])
    end
    user
  end

  private

  def self.create_from_auth_hash(auth_details)
    User.create({
        uid: auth_details[:uid],
        name: auth_details[:info][:name],
        email: auth_details[:info][:email],
        token: auth_details[:credentials][:token]
                })
  end
end
