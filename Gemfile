source 'https://rubygems.org'

ruby '2.1.1'

# Rails
gem 'rails', '4.1.0'
gem 'rails-api'
gem 'rails_12factor', group: :production

# Database
gem 'pg'

# Assets
gem 'sass-rails', '~> 4.0.2'
gem 'uglifier', '>= 1.3.0'

# API
gem 'active_model_serializers'
gem 'jbuilder', '~> 2.0.5'
gem 'rack-cors'

# OpenID/Google Apps Auth
gem 'omniauth-google-oauth2'

# Utilities
gem 'cancan', '~> 1.6.10'
gem 'figaro', github: 'laserlemon/figaro'
gem 'timecop'

group :doc do
  gem 'sdoc', require: false
end

group :development, :test do
  gem 'rspec',        '~> 2.14.1'
  gem 'rspec-rails',  '~> 2.14.1'
  gem 'guard',        '~> 2.6.0'
  gem 'guard-rspec',  '~> 4.2.7'
  gem 'pry'
  gem 'pry-stack_explorer'
  gem 'pry-remote'
  gem 'pry-nav'
end

group :development do
  gem 'spring',                '~> 1.1.2'
  gem 'spring-commands-rspec', '~> 1.0.1'
end

group :test do
  gem 'codeclimate-test-reporter', require: nil
  gem 'coveralls', require: false
  gem 'fakeweb', '~> 1.3'
  gem 'growl', '1.0.3'
  gem 'json_spec'
end
