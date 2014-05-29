require 'timecop'
require_relative '../../../lib/aws/client'

describe AWS::Client do
  let(:access_key) { 'access_key' }
  let(:secret_key) { 'secret_key' }
  subject(:client) { AWS::Client.new(access_key, secret_key) }

  describe '.new' do
    it { should be_a AWS::Client }

    context 'when access_key is missing' do
      let(:access_key) { nil }

      it 'should raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, /access_key/)
      end
    end

    context 'when secret_key is missing' do
      let(:secret_key) { nil }

      it 'should raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError, /secret_key/)
      end
    end
  end

  describe '#signing_date' do
    let(:expected) { 'Thu, 29 May 2014 00:30:15 +0000' }
    let(:time) { Time.new(2014, 5, 29, 0, 30, 15, '+00:00') }

    it 'returns formatted UTC time' do
      Timecop.freeze(time) do
        expect(client.signing_date).to eq(expected)
      end
    end
  end

  describe '#generate_signature' do
    let(:hmac) { 'an hmac' }
    let(:expected) { Base64.encode64(hmac).gsub("\n", '') }
    before { client.stub(:hmac_sha1 => hmac) }

    subject { client.generate_signature('asdf') }

    it { should eq expected }
  end

  describe '#generate_authorization' do
    before { client.stub(:generate_signature => 'fake_signature') }

    subject { client.generate_authorization('asdf') }

    it { should eq "AWS #{access_key}:fake_signature" }
  end

  describe '#build_request' do
    let(:method) { 'PUT' }
    let(:uri) { URI('http://example.com') }
    let(:object) { double() }
    let(:signing_date) { 'expected date' }
    let(:authorization) { 'expected authorization' }
    let(:headers) { 'expected headers' }
    before {
      client.stub(:signing_date => signing_date)
      object.stub(:signing_string).with(method, signing_date).and_return('signing-string')
      client.stub(:generate_authorization).with('signing-string').and_return(authorization)
      object.stub(:request_headers).with(signing_date, authorization).and_return(headers)
      Net::HTTP::Put.stub(:new)
    }

    it 'creates a Net::HTTP::Put instance with the uri and headers' do
      client.build_request(method, uri, object)

      expect(Net::HTTP::Put).to have_received(:new).with(uri, headers)
    end
  end

  describe '#make_request' do
    let(:method) { 'PUT' }
    let(:uri) { URI('http://example.com') }
    let(:object) { double() }
    let(:http) { double(:use_ssl= => nil, :request => nil) }
    let(:request) { double() }
    before {
      Net::HTTP.stub(:new).with(uri.host, uri.port).and_return(http)
      client.stub(:build_request).with(method, uri, object).and_return(request)
      object.stub(:setup_request)
    }

    context 'when URI scheme is https' do
      let(:uri) { URI('https://example.com') }

      it 'sets the http use_ssl flag' do
        client.make_request(method, uri, object)

        expect(http).to have_received(:use_ssl=).with(true)
      end
    end

    it 'calls setup_request on the object' do
      client.make_request(method, uri, object)

      expect(object).to have_received(:setup_request).with(request)
    end

    it 'executes the request' do
      client.make_request(method, uri, object)

      expect(http).to have_received(:request).with(request)
    end
  end
end

