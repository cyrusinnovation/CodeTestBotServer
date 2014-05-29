require_relative '../../../../lib/aws/s3/client'

describe AWS::S3::Client do
  let(:aws_client) { double() }
  subject(:client) { AWS::S3::Client.new(aws_client) }

  describe '.new' do
    it { should be_a AWS::S3::Client }

    context 'when aws_client is missing' do
      let(:aws_client) { nil }

      it 'should raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, /aws_client/)
      end
    end
  end

  describe '#make_request' do
    before { aws_client.stub(:make_request) }

    it 'delegates to the aws_client' do
      client.make_request('method', 'uri', 'object')

      expect(aws_client).to have_received(:make_request).with('method', 'uri', 'object')
    end
  end
end
