require_relative '../../lib/aws'

describe AWS do
  describe '.setup' do
    before { AWS::Client.stub(:new) }
    
    it 'creates Client with keys' do
      AWS.setup('access_key', 'secret_key')

      expect(AWS::Client).to have_received(:new).with('access_key', 'secret_key')
    end
  end
end
