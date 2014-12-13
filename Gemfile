source 'https://rubygems.org'
gem 'rails', '~> 4.1.6'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'
gem 'font-awesome-sass', '~> 4.2.0'
gem 'warden'
gem 'bcrypt'
gem 'active_model_serializers'

#Polymer Project
gem 'emcee'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'moped', github: 'mongoid/moped'
gem 'mongoid', github: 'mongoid/mongoid'
gem 'mongoid_slug'
gem 'omniauth', '~> 1.1.4'
gem 'omniauth-vkontakte', '~> 1.3.2'
gem 'omniauth-gplus', '~> 2.0'
gem 'cancan'
gem 'kaminari'
gem 'sidekiq'
gem 'select2-rails'
gem 'faraday'
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem 'mini_magick'
gem 'cocoon'
gem 'sinatra', '>= 1.3.0', :require => nil #For Sidekiq WEB
gem 'unicorn'
gem 'rsolr'
gem 'newrelic_rpm'
gem 'whenever', require: false
gem 'geocoder'

group :test, :development do
  gem 'thin'
  #TODO remove this when rspec-bug with AR is fixed
  gem 'rspec-rails'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'capybara'
  gem 'pry-rails'
  gem 'sunspot_solr'
  gem 'letter_opener'
  #gem 'pry-debugger'
end

group :development do
  gem 'better_errors'
  gem 'capistrano'
  gem 'capistrano-bower'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-sidekiq'
end

group :production do
  gem 'execjs'
  gem 'therubyracer', platforms: :ruby
  gem 'rails_12factor'
end
