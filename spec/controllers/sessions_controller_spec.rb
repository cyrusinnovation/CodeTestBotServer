require 'spec_helper'

describe SessionsController do

  describe 'GET new' do
    it 'returns error if no redirect_uri given' do
      get :new
      expect(response).to be_bad_request

      expected_error = {error: 'Missing required parameter: redirect_uri'}
      expect(response.body).to eq(expected_error.to_json)
    end

    it 'returns error if redirect_uri is not a valid uri' do
      get :new, {redirect_uri: 'test'}
      expect(response).to be_bad_request

      expected_error = {error: 'Parameter redirect_uri must be a valid HTTP/HTTPS URI.'}
      expect(response.body).to eq(expected_error.to_json)
    end

    it 'returns success and auth_uri if request ok' do
      fake_env = double(:fake_env)
      allow(Figaro).to receive(:env).and_return fake_env

      allow(fake_env).to receive(:base_uri).and_return 'http://example.com'
      redirect_uri = 'http://example.com/auth/complete'
      params = {redirect_uri: redirect_uri}
      state = URI.encode_www_form(params)

      get :new, params
      expect(response).to be_ok
      expect(response.body).to eq({auth_uri: "http://example.com/auth/google?state=#{state}"}.to_json)
    end

    # TODO: Add CSRF token to state

    it 'returns the development token route if the USE_DEV_TOKEN env var is set' do
      fake_env = double(:fake_env)
      allow(Figaro).to receive(:env).and_return fake_env
      allow(fake_env).to receive(:base_uri).and_return 'http://example.com'
      allow(fake_env).to receive(:use_dev_token).and_return true
      redirect_uri = 'http://example.com/auth/complete'
      params = {redirect_uri: redirect_uri}
      state = URI.encode_www_form(params)

      get :new, params
      expect(response).to be_ok
      expect(response.body).to eq({auth_uri: "http://example.com/auth/development_token?state=#{state}"}.to_json)
    end

    it 'returns the google auth route if USE_DEV_TOKEN is not set to true' do
      fake_env = double(:fake_env)
      allow(Figaro).to receive(:env).and_return fake_env
      allow(fake_env).to receive(:base_uri).and_return 'http://example.com'

      redirect_uri = 'http://example.com/auth/complete'
      params = {redirect_uri: redirect_uri}
      state = URI.encode_www_form(params)

      get :new, params
      expect(response.status).to eq(200)
      expect(response.body).to eq({auth_uri: "http://example.com/auth/google?state=#{state}"}.to_json)

      allow(fake_env).to receive(:use_dev_token).and_return false
      get :new, params
      expect(response.status).to eq(200)
      expect(response.body).to eq({auth_uri: "http://example.com/auth/google?state=#{state}"}.to_json)
    end
  end

  describe :show do
    it 'returns 403 if no Authorization header present' do
      get :show, :id => 'current'

      expect(response).to be_forbidden
    end

    it 'returns 403 if no session exists' do
      @request.headers['Authorization'] = 'Bearer 1234'
      get :show, :id => 'current'

      expect(response).to be_forbidden
    end

    it 'returns 403 if session expired' do
      token = '123456789'
      expiry = Time.now.utc - 1.second
      user = User.create({ name: 'Bob', email: 'bob@example.com' })
      Session.create({token: token, token_expiry: expiry, user: user})

      @request.headers['Authorization'] = "Bearer #{token}"
      get :show, :id => 'current'

      expect(response).to be_forbidden
    end

    it 'returns a session as JSON with the user' do
      token = '123456789'
      expiry = Time.now.utc + 20.minutes
      user = User.create({ name: 'Bob', email: 'bob@example.com' })
      Session.create({token: token, token_expiry: expiry, user: user})

      @request.headers['Authorization'] = "Bearer #{token}"
      get :show, :id => 'current'

      expected_session = { token: token, token_expiry: expiry, user_id: user.id }
      expected_user = [{name: user.name, email: user.email}]
      expect(response.body).to be_json_eql(expected_session.to_json).at_path('session')
      expect(response.body).to be_json_eql(expected_user.to_json).at_path('users')
    end
  end
end
