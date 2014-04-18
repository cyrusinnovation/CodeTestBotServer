shared_examples 'a secured route' do
  let!(:user) { User.create({ name: 'Bob', email: 'bob@example.com' }) }

  context 'when Authorization header is missing' do
    it { should be_unauthorized }
    it { should have_header_value('WWW-Authenticate', 'Bearer') }
  end

  context 'when Authorization header is invalid' do
    let!(:authorization) { @request.headers['Authorization'] = 'Unknown xenotoken' }
    it { should be_bad_request }
    it { should have_header_value('WWW-Authenticate', 'Bearer error="invalid_request"') }
  end

  context 'when session does not exist' do
    let!(:authorization) { @request.headers['Authorization'] = 'Bearer 1234' }
    it { should be_unauthorized }
    it { should have_header_value('WWW-Authenticate', 'Bearer error="invalid_token", error_description="Access Token Expired"') }
  end

  context 'when session is expired' do
    let!(:authorization) { expired_token }
    it { should be_unauthorized }
    it { should have_header_value('WWW-Authenticate', 'Bearer error="invalid_token", error_description="Access Token Expired"') }
  end

  def expired_token
    token = '123456789'
    expiry = Time.now.utc - 1.second
    Session.create({token: token, token_expiry: expiry, user: user})

    @request.headers['Authorization'] = "Bearer #{token}"
  end
end
