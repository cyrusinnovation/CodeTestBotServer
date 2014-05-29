
module AWS
  module S3
    class Client
      extend Forwardable

      def_delegator :@aws, :make_request

      def initialize(aws_client)
        raise ArgumentError.new('aws_client is required') if aws_client.nil?

        @aws = aws_client
      end

      def bucket(bucket_name)
        Bucket.new(self, bucket_name)
      end
    end
  end
end

