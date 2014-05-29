require_relative '../../../../lib/aws/s3/s3_object'
require 'net/http'

describe AWS::S3::S3Object do
  let(:signing_date) { 'fake_date_string' }
  let(:bucket) { double(:name => 'test-bucket') }
  let(:object_name) { 'test-object' }
  subject(:object) { AWS::S3::S3Object.new(bucket, object_name) }

  describe '#body' do
    it { should respond_to(:body, :body=) }

    it 'nils body_stream on set' do
      object.body_stream = 'a stream'

      expect { object.body = 'test' }.to change(subject, :body_stream).from('a stream').to(nil)
    end
  end
  
  describe '#body_stream' do
    it { should respond_to(:body_stream, :body_stream=) }

    it 'nils body on set' do
      object.body = 'test'

      expect { object.body_stream = 'a stream' }.to change(subject, :body).from('test').to(nil)
    end
  end

  describe '#headers' do
    it { should respond_to(:headers) }

    describe 'defaults' do
      subject { object.headers }

      it { should include 'Content-Type' => 'application/x-www-form-urlencoded' }
      it { should include 'Expect' => '100-continue' }
    end
  end
  
  it { should respond_to(:acl, :acl=) }

  describe '#request_headers' do
    subject { object.request_headers }

    it { should include object.headers }
    it { should_not include 'Date' }
    it { should_not include 'Authorization' }

    context 'when body set' do
      before { object.body = "\x80\u3042" }

      it { should include 'Content-Length' => '4' }
    end

    context 'when body_stream set' do
      before { object.body_stream = double(:size => 42) }

      it { should include 'Content-Length' => '42' }
    end
    
    context 'when acl set' do
      before { object.acl = 'public-read' }

      it { should include 'x-amz-acl' => 'public-read' }
    end

    describe 'Date header' do
      subject { object.request_headers(signing_date) }

      it { should include 'Date' => signing_date }
    end

    describe 'Authorization header' do
      let(:authorization) { 'fake_authorization_string' }
      subject { object.request_headers(signing_date, authorization) }

      it { should include 'Authorization' => authorization }
    end
  end

  describe '#signing_string' do
    let(:method) { 'PUT' }
    before {
      object.acl = 'public-read' 
      object.headers['Content-Type'] = 'something/else'
    }
    subject { object.signing_string(method, signing_date) }

    it { should eq "#{method}

something/else
#{signing_date}
x-amz-acl:public-read
/#{bucket.name}/#{object_name}" 
    }
  end
end

