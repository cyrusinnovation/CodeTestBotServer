
module AWS
  module S3
    class S3Object
      attr_reader :body, :body_stream, :headers, :name
      attr_accessor :acl

      def initialize(bucket, object_name)
        @bucket = bucket
        @name = object_name
        @headers = {
          'Content-Type' => 'application/x-www-form-urlencoded',
          'Expect' => '100-continue'
        }
      end

      def body=(data)
        @body = data
        @body_stream = nil
      end

      def body_stream=(stream)
        @body_stream = stream
        @body = nil
      end

      def request_headers(date = nil, authorization = nil)
        headers = @headers.clone
        headers['Authorization'] = authorization unless authorization.nil?
        headers['Content-Length'] = body_size
        headers['Date'] = date unless date.nil?
        headers['x-amz-acl'] = @acl
        headers
      end

      def signing_string(method, date)
        canonical_resource = "/#{@bucket.name}/#{@name}"
        canonical_headers = canonicalized_amazon_headers(request_headers)
        "#{method}\n\n#{headers['Content-Type']}\n#{date}\n#{canonical_headers}#{canonical_resource}"
      end

      def setup_request(request)
        if body_stream.nil?
          request.body = body unless body.nil?
        else
          request.body_stream = body_stream
        end
      end

      private

      def body_size
        if body_stream.nil?
          body.bytesize.to_s unless body.nil?
        else
          body_stream.size.to_s
        end
      end

      def canonicalized_amazon_headers(headers)
        downcased_headers = {}
        headers.each { |k, v| downcased_headers[k.downcase] = v }
        amz_headers = downcased_headers.select { |k, v| k.start_with? 'x-amz-' }
        header_names = amz_headers.keys.sort
        header_names.reduce('') { |str, h| str + "#{h}:#{amz_headers[h]}\n" }
      end
    end
  end
end

