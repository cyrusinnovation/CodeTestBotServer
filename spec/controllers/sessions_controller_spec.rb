require 'spec_helper'

describe SessionsController do

  describe 'GET new' do
    it 'returns error if no redirect_uri given' do
      get :new
      expect(response.status).to eq(400)

      expected_error = {error: 'Missing required parameter redirect_uri.'}
      expect(response.body).to eq(expected_error.to_json)
    end

    it 'returns error if redirect_uri is not a valid uri' do
      get :new, {redirect_uri: 'test'}
      expect(response.status).to eq(400)

      expected_error = {error: 'Parameter redirect_uri must be a valid HTTP/HTTPS URI.'}
      expect(response.body).to eq(expected_error.to_json)
    end

    it 'returns success and auth_uri if request ok' do
      ENV['BASE_URI'] = 'http://example.com'
      redirect_uri = 'http://example.com/auth/complete'
      encoded_uri = URI.encode_www_form_component redirect_uri

      get :new, {redirect_uri: redirect_uri}
      expect(response.status).to eq(200)
      expect(response.body).to eq({auth_uri: "http://example.com/auth/google?state=#{encoded_uri}"}.to_json)
    end

    # TODO: Add CSRF token to state
  end

end
