require 'spec_helper'

describe SessionsController do

  describe '#new' do
    let(:env) { fake_env }
    let!(:base_uri) { allow(env).to receive(:base_uri).and_return 'http://example.com' }
    let(:params) { { redirect_uri: 'http://example.com/auth/complete' } }
    let(:state) { URI.encode_www_form(params) }
    let(:google_auth_uri) { "http://example.com/auth/google?state=#{state}" }
    let(:dev_auth_uri) { "http://example.com/auth/development_token?state=#{state}" }

    subject(:response) { get :new, params }

    context 'when redirect_uri is missing' do
      let(:params) { {} }
      it { should be_bad_request }
      it { should match_json('Missing required parameter: redirect_uri', 'error') }
    end

    context 'when redirect_uri is invalid' do
      let(:params) { { redirect_uri: 'test' } }
      it { should be_bad_request }
      it { should match_json('Parameter redirect_uri must be a valid HTTP/HTTPS URI.', 'error') }
    end

    context 'when request is ok' do
      it { should be_ok }
      it { should match_json(google_auth_uri, 'auth_uri')}
    end

    context 'when USE_DEV_TOKEN is set' do
      let!(:use_dev_token) { allow(env).to receive(:use_dev_token).and_return 'true' }
      it { should be_ok }
      it { should match_json(dev_auth_uri, 'auth_uri')}
    end

    context 'when USE_DEV_TOKEN is set but not true' do
      let!(:use_dev_token) { allow(env).to receive(:use_dev_token).and_return 'false' }
      it { should be_ok }
      it { should match_json(google_auth_uri, 'auth_uri')}
    end

    # TODO: Add CSRF token to state
  end

  describe '#show' do
    let(:env) { fake_env }
    let(:time) { Time.now.utc }
    let!(:user) { User.create({ name: 'Bob', email: 'bob@example.com' }) }
    let(:fake_user)  { User.create({ name: 'Development User', email: 'dev@localhost', uid: 'dev' }) }

    subject(:response) {
      Timecop.freeze(time) do
        get :show, :id => 'current'
      end
    }

    it_behaves_like 'a secured route'

    context 'when auth headers exist and USE_DEV_TOKEN is not set' do
      let(:token) { '123456789' }
      let(:expiry) { time + 90.minutes }
      let!(:authorization) { valid_token(token, expiry) }
      it { should be_ok }
      it 'should return current user session as JSON' do
        expected_session_json = { token: token, token_expiry: expiry, user_id: user.id }.to_json
        expect(response.body).to be_json_eql(expected_session_json).at_path('session')
      end
    end

    context 'when auth headers exist and USE_DEV_TOKEN is set' do
      let!(:use_dev_token) { allow(env).to receive(:use_dev_token).and_return 'true' }
      let(:token) { '123456789' }
      let(:expiry) { time + 90.minutes }
      let!(:authorization) { valid_token(token, expiry) }
      it { should be_ok }
      it 'should return the real user not the fake user if there is a a real user' do
        expected_session_json = { token: token, token_expiry: expiry, user_id: user.id }.to_json
        expect(response.body).to be_json_eql(expected_session_json).at_path('session')
      end
    end

    context 'when USE_DEV_TOKEN is set to true and there are no other auth headers' do
      let!(:use_dev_token) { allow(env).to receive(:use_dev_token).and_return 'true' }
      it { should be_ok }
      it 'should return fake user id in the session as JSON' do
        expected_session_json = fake_user.id
        expect(response.body).to be_json_eql(expected_session_json).at_path('session/user_id')
      end
    end

    context 'when USE_DEV_TOKEN is set to false and there are no other auth headers' do
      let!(:use_dev_token) { allow(env).to receive(:use_dev_token).and_return 'false' }
      it { should be_unauthorized }
    end


    context 'when auth headers exist and session expiry is less than an hour' do
      let(:token) { '123456789' }
      let(:an_hour_from_now) { time + 1.hour }
      let(:expiry) { time + 5.minutes }
      let!(:authorization) { valid_token(token, expiry) }
      it { should be_ok }
      it 'should reset the session expiry for an hours time' do
        expected_session_json = { token: token, token_expiry: an_hour_from_now, user_id: user.id }.to_json
        expect(response.body).to be_json_eql(expected_session_json).at_path('session')
      end
    end

    context 'when auth headers exist and session expiry is more than an hour' do
      let(:token) { '123456789' }
      let(:expiry) { time + 75.minutes }
      let!(:authorization) { valid_token(token, expiry) }
      it { should be_ok }
      it 'should leave the session expiry time unchanged' do
        expected_session_json = { token: token, token_expiry: expiry, user_id: user.id }.to_json
        expect(response.body).to be_json_eql(expected_session_json).at_path('session')
      end
    end

    def valid_token(token, expiry)
      Session.create({token: token, token_expiry: expiry, user: user})

      @request.headers['Authorization'] = "Bearer #{token}"
    end
  end
end
