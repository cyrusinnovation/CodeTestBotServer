require_relative '../../../lib/aws/s3'

describe AWS::S3 do
  describe '.setup' do
    let(:access_key) { 'access_key' }
    let(:secret_key) { 'secret_key' }
    let(:expected_aws_client) { double() }
    before {
      AWS.stub(:setup => expected_aws_client)
      AWS::S3::Client.stub(:new)
    }

    it 'sets up an AWS::Client and uses it to create an S3 client' do
      AWS::S3.setup(access_key, secret_key)

      expect(AWS::S3::Client).to have_received(:new).with(expected_aws_client)
    end
  end
end

