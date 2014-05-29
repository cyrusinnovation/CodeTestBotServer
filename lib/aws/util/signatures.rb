
module AWS
  module Util
    module Signatures
      def hmac_sha1(secret_key, value)
        sha1 = OpenSSL::Digest.new('sha1')
        OpenSSL::HMAC.digest(sha1, secret_key, value)
      end
    end
  end
end

