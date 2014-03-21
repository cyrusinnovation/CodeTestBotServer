require 'omniauth-openid'
require 'openid/fetchers'
require 'openid/store/filesystem'
require 'gapps_openid'

OpenID.fetcher.ca_file = ENV['CACERT_PATH']

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :open_id, :name => 'google',
                     :identifier => 'https://www.google.com/accounts/o8/id',
                     :store => OpenID::Store::Filesystem.new('/tmp')
end