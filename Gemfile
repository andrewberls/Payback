source 'http://rubygems.org'

ruby '2.0.0'

gem "rails", "~> 3.2.13"

gem 'pg'

gem 'heroku'

gem 'therubyracer', :platforms => :ruby

gem 'bcrypt-ruby', '~> 3.0.0'

gem 'jquery-rails'

gem 'unicorn'

gem 'active_model_serializers', :github => 'rails-api/active_model_serializers'

gem 'sidekiq'

gem 'notes-cli'

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'letter_opener' # Preview emails in browser instead of sending

  gem 'launchy', '2.3.0' # Open browser to show rendering

  gem 'sqlite3'

  gem 'better_errors'
  gem 'binding_of_caller'

  gem "rspec-rails", "~> 2.14.0"
  gem "factory_girl_rails", "~> 4.2.1"
  gem "faker", "~> 1.2.0"
end

group :test do
  gem "database_cleaner", "~> 1.0.1" # Clear data for each spec run
end
