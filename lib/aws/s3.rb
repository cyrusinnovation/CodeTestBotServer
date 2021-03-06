require_relative 's3/client'

module AWS
  module S3
    def self.setup(access_key, secret_key)
      aws = AWS.setup(access_key, secret_key)
      AWS::S3::Client.new(aws)
    end
  end
end
