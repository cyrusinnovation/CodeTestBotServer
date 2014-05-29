require 'base64'
require_relative 'util/signatures'

module AWS
  class Client
    include AWS::Util::Signatures

    def initialize(access_key, secret_key)
      raise ArgumentError.new('access_key is required') if access_key.nil?
      raise ArgumentError.new('secret_key is required') if secret_key.nil?

      @access_key = access_key
      @secret_key = secret_key
    end

    def make_request(method, uri, object)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == 'https')

      request = build_request(method, uri, object)
      object.setup_request(request)

      http.request(request)
    end

    def signing_date
      format = '%a, %d %b %Y %T %z'
      Time.now.utc.strftime(format)
    end

    def generate_authorization(signing_string)
      signature = generate_signature(signing_string)
      "AWS #{@access_key}:#{signature}"
    end

    def generate_signature(value)
      hmac = hmac_sha1(@secret_key, value)
      Base64.encode64(hmac).gsub("\n", '')
    end

    def build_request(method, uri, object)
      methods = {
        'PUT' => Net::HTTP::Put
      }

      date = signing_date
      authorization = generate_authorization(object.signing_string(method, date))
      methods.fetch(method).new(uri, object.request_headers(date, authorization))
    end
  end
end

#aws = AWS.setup(a, s)

#s3 = aws.s3
#s3 = AWS::S3.setup(a, s)

#bucket = s3.bucket('name')
#bucket.put_object('name', file)
