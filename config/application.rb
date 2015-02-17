require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"
require 'carrierwave'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module PlayhardCore
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths += %W(#{config.root}/app/presenters #{config.root}/app/serializers #{config.root}/app/services #{config.root}/app/decorators #{config.root}/lib #{config.root}/lib/providers #{config.root}/app/validators)

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', 'rails', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ru

    #TODO this is dirty HACK!!! Need to remove after I18n updates
    config.i18n.locale = :ru

    config.harvester = ActiveSupport::OrderedOptions.new
  end
end
