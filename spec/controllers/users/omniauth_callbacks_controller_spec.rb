require 'rspec'

describe Users::OmniauthCallbacksController do
  describe :development_token do
    before(:each) do
      @original_env = Rails.env
    end

    after(:each) do
      Rails.env = @original_env
    end

    describe 'in development mode' do
      before(:each) do
        Rails.env = 'development'
        @params = {:state => URI::encode_www_form({redirect_uri: 'http://client/complete'})}
      end

      it 'redirects to the client redirect_uri with a token' do
        allow(SecureRandom).to receive(:hex).and_return('arandomhexstring')
        get :development_token, @params

        expect(response).to redirect_to('http://client/complete?token=arandomhexstring&expires_at=0')
      end

      it 'creates a dev user if one does not exist' do
        get :development_token, @params

        expect(User.count).to eq(1)
        expect(User.first.uid).to eq('dev')
        expect(User.first.name).to eq('Development User')
        expect(User.first.email).to eq('dev@localhost')
      end

      it 'creates a session for the dev user' do
        allow(SecureRandom).to receive(:hex).and_return('arandomhexstring')
        get :development_token, @params

        expect(Session.count).to eq(1)
        expect(Session.first.user).to eq(User.first)
        expect(Session.first.token).to eq('arandomhexstring')
        expect(Session.first.token_expiry).to eq(Time.at(0))
      end
    end

    it 'responds with 403 if not in development mode' do
      Rails.env = 'production'

      get :development_token

      expect(response).to be_forbidden
    end
  end

end