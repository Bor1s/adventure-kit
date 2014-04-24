source 'https://rubygems.org'
gem 'rails', '4.0.4'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'moped', github: 'mongoid/moped'
gem 'mongoid', github: 'mongoid/mongoid'
gem 'omniauth', '~> 1.1.4'
gem 'omniauth-vkontakte', '~> 1.2.0'
gem 'cancan'
gem 'kaminari'
gem 'sidekiq'
gem "select2-rails"
gem 'faraday'
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem 'mini_magick'
gem 'cocoon'
gem 'sinatra', '>= 1.3.0', :require => nil #For Sidekiq WEB
gem 'unicorn'
gem 'sunspot_rails'
gem 'sunspot_solr'

group :test, :development do
  gem 'thin'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'pry-rails'
  #gem 'pry-debugger'
end

group :development do
  gem 'better_errors'
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-sidekiq' , github: 'seuros/capistrano-sidekiq'
end

group :production do
  gem 'execjs'
  gem 'therubyracer', platforms: :ruby
  gem 'rails_12factor'
end
