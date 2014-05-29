require_relative 'client'

module AWS
  def self.setup(access_key, secret_key)
    Client.new(access_key, secret_key)
  end
end
