require_relative 's3_object'

module AWS
  module S3
    class Bucket
      attr_reader :name

      def initialize(s3_client, bucket_name)
        raise ArgumentError.new('s3_client is required') if s3_client.nil?
        raise ArgumentError.new('bucket_name is required') if bucket_name.nil? || bucket_name.strip.empty?

        @client = s3_client
        @name = bucket_name
      end

      def put_object_stream(object_name, stream)
        object = S3Object.new(self, object_name)
        if block_given?
          yield(object)
        end

        object.body_stream = stream
        put(object)
      end

      def put(object)
        @client.make_request('PUT', bucket_uri(object), object)
        object
      end

      def bucket_uri(object)
        URI("https://#{@name}.s3.amazonaws.com/#{object.name}")
      end
    end
  end
end

