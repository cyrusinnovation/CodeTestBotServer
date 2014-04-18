class User < ActiveRecord::Base
  has_many :sessions
  has_and_belongs_to_many :roles

  def remove_role(role)
    if roles.count == 1
      raise HttpStatus::Forbidden.new('Cannot remove all roles from a User.')
    end

    roles.delete(role)
  end

  def remove_role!(role)
    remove_role(role)
    save
  end

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
        email: auth_details[:info][:email],
        roles: [Role.find_by_name('Assessor')]
                })
  end
end
