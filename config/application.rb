require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'geoip'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Scd
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    config.time_zone = 'Pacific Time (US & Canada)'
    config.assets.enabled = true

    #config.action_controller.asset_host = "https://d2hpyijb4a66bq.cloudfront.net"
    #config.action_mailer.asset_host = config.action_controller.asset_host

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end
