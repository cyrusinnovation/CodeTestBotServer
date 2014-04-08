class User < ActiveRecord::Base
  has_many :sessions
  belongs_to :role

  def self.find_or_create_from_auth_hash(auth_details)
    user = User.find_by_uid(auth_details[:uid])
    if user == nil
      user = create_from_auth_hash auth_details
    end
    user
  end

  private

  def self.create_from_auth_hash(auth_details)
    User.create({
        uid: auth_details[:uid],
        name: auth_details[:info][:name],
        email: auth_details[:info][:email]
                })
  end
end
