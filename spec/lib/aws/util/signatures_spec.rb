require_relative '../../../../lib/aws/util/signatures'

describe AWS::Util::Signatures do
  let(:dummy_class) { Class.new { include AWS::Util::Signatures } }
  before(:each) { @dummy = dummy_class.new }

  describe '.hmac_sha1' do
    let(:secret_key) { 'secret_key' }
    let(:value) { 'some value' }

    it 'generates a SHA-1 HMAC from a secret_key and string value' do
      expected = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'), secret_key, value)

      expect(@dummy.hmac_sha1(secret_key, value)).to eq(expected)
    end
  end
end
