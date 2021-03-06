PlayhardCore::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log


  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Mailer
  #config.action_mailer.delivery_method = :smtp
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.smtp_settings = {
    address:              'smtp.gmail.com',
    port:                 587,
    domain:               'example.com',
    user_name:            'noreply.playhardrpg@gmail.com',
    password:             'd3c0mpr3ss10n',
    authentication:       'plain',
    enable_starttls_auto: true }

  config.action_mailer.default_url_options = { host: 'localhost:3000' }

  config.harvester.host = 'http://localhost:3001'
  config.solr_url = "http://localhost:8983/solr/development"

  Rails.application.routes.default_url_options[:host] = 'localhost:3000'
end
