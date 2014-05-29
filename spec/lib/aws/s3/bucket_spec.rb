require_relative '../../../../lib/aws/s3/bucket'

describe AWS::S3::Bucket do
  let(:s3_client) { double() }
  let(:bucket_name) { 'bucket' }
  subject(:bucket) { AWS::S3::Bucket.new(s3_client, bucket_name) }

  describe '.new' do
    it { should be_a AWS::S3::Bucket }

    context 'when s3_client is missing' do
      let(:s3_client) { nil }

      it 'should raise ArgumentError' do
        expect { bucket }.to raise_error(ArgumentError, /s3_client/)
      end
    end

    context 'when bucket_name is missing' do
      it 'should raise ArgumentError' do
        expect { AWS::S3::Bucket.new(s3_client, nil) }.to raise_error(ArgumentError, /bucket_name/)
        expect { AWS::S3::Bucket.new(s3_client, '') }.to raise_error(ArgumentError, /bucket_name/)
        expect { AWS::S3::Bucket.new(s3_client, '  ') }.to raise_error(ArgumentError, /bucket_name/)
      end
    end
  end

  describe '#put_object_stream' do
    let(:object_name) { 'test-object' }
    let(:stream) { double() }
    before { bucket.stub(:put) }

    it 'passes a created S3Object instance to the given block' do
      instance = nil
      bucket.put_object_stream(object_name, stream) do |obj|
        instance = obj
      end

      expect(instance).to_not be_nil
      expect(instance.name).to eq(object_name)
      expect(instance.body_stream).to eq(stream)
    end

    it 'calls #put with the created instance' do
      instance = nil
      bucket.put_object_stream(object_name, stream) do |obj|
        instance = obj
      end

      expect(bucket).to have_received(:put).with(instance)
    end
  end

  describe '#put' do
    let(:object) { double(:name => 'test-object') }
    let(:expected_uri) { URI("https://#{bucket_name}.s3.amazonaws.com/#{object.name}") }
    before { s3_client.stub(:make_request) }

    it 'delegates to client.make_request' do
      bucket.put(object)

      expect(s3_client).to have_received(:make_request).with('PUT', expected_uri, object)
    end
  end
end

