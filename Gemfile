source 'https://rubygems.org'

ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.4'

# Use postgresql as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.2'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# OpenID/Google Apps Auth
gem 'omniauth-google-oauth2'

# Paperclip and AWS sdk for uploading zip files to S3
gem 'paperclip',  '~> 3.5.1'
gem 'aws-sdk',    '~> 1.8.5'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'rails-api'
gem 'rails_12factor'
gem 'rack-cors'
gem 'active_model_serializers'

gem 'figaro'

group :development, :test do
  gem 'rspec',        '~> 2.14.1'
  gem 'rspec-rails',  '~> 2.14.1'
  gem 'guard',        '~> 2.6.0'
  gem 'guard-rspec',  '~> 4.2.7'
end

group :test do
  gem 'codeclimate-test-reporter', require: nil
  gem 'coveralls', require: false
  gem 'fakeweb', '~> 1.3'
  gem 'growl', '1.0.3'
  gem 'json_spec'
  gem 'simplecov', '~> 0.7.1'
end
