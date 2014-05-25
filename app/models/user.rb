class User < ActiveRecord::Base
  has_many :sessions
  belongs_to :role

  def self.find_or_create_from_auth_hash(auth_details)
    user = User.find_by_uid(auth_details[:uid])
    if user == nil
      user = create_from_auth_hash auth_details
    else
      update_from_auth_hash(user, auth_details)
    end
    user
  end

  private

  def self.update_from_auth_hash(user, auth_details)
    info = auth_details[:info]
    user.update_attributes({
      name: info[:name],
      image_url: info[:image]
    })
  end

  def self.create_from_auth_hash(auth_details)
    User.create({
        uid: auth_details[:uid],
        name: auth_details[:info][:name],
        email: auth_details[:info][:email],
        image_url: auth_details[:info][:image],
        editable: auth_details.key?(:editable) ? auth_details[:editable] : true,
        role: auth_details.key?(:role) ? auth_details[:role] : Role.find_by_name('Assessor')
                })
  end
end
