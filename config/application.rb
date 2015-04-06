require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CodeTestBotServer
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += %W(#{config.root}/app/services)
    config.autoload_paths += %W(#{config.root}/app)

    config.middleware.use "ActionDispatch::Cookies"
    config.middleware.use "ActionDispatch::Session::CookieStore"
    config.middleware.use "ActionDispatch::Flash"

    config.middleware.use Rack::Cors do
      allow do
        origins 'codetestbot.herokuapp.com', 'localhost:4200', 'codetestbot-staging.herokuapp.com'
        resource '*',
                 :methods => [:get, :post, :put, :delete, :options],
                 :headers => :any,
                 :expose => ['WWW-Authenticate']
      end
    end

    config.action_mailer.smtp_settings = {
        :address => ENV['SMTP_HOST'],
        :port => ENV['SMTP_PORT'],
        :user_name => ENV['SMTP_USERNAME'],
        :password => ENV['SMTP_PASSWORD'],
        :domain => ENV['SMTP_DOMAIN'],
        :authentication => :login,
        :enable_starttls_auto => true
    }
  end
end
