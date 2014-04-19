require 'rspec'

describe OmniauthCallbacksController do
  before { @original_env = Rails.env }
  after { Rails.env = @original_env }

  describe '#development_token' do
    let(:params) { {:state => URI::encode_www_form({redirect_uri: 'http://client/complete'})} }
    let(:time) { Time.now.utc }
    let(:token) { 'arandomhexstring' }
    let!(:secure_random) { allow(SecureRandom).to receive(:hex).and_return(token) }

    subject(:response) {
      Timecop.freeze(time) do
        get :development_token, params
      end
    }

    context 'when in development mode' do
      before { Rails.env = 'development' }

      it { should redirect_to "http://client/complete?token=#{token}&expires_at=#{(time + 1.day).to_i}" }

      it 'creates a dev user if one does not exist' do
        expect(response.status).to be_found
        expect(User.count).to eq(1)
        expect(User.first.uid).to eq('dev')
        expect(User.first.name).to eq('Development User')
        expect(User.first.email).to eq('dev@localhost')
        expect(User.first.editable).to be_false
        expect(User.first.roles).to include(Role.find_by_name('Administrator'))
      end

      it 'creates a session for the dev user' do
        expect(response.status).to be_found
        expect(Session.count).to eq(1)
        expect(Session.first.user).to eq(User.first)
        expect(Session.first.token).to eq(token)
        expect(Session.first.token_expiry).to eq(Time.at((time + 1.day).to_i))
      end
    end

    context 'when not in development mode' do
      before { Rails.env = 'production' }

      it { should be_forbidden }
    end
  end
end
