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

gem "sidekiq", "~> 2.17.4"

gem 'notes-cli'

gem 'test-unit'

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

end

group :test do
  gem 'guard-rspec', '~> 4.2.5'
  gem "rspec-rails", "~> 2.14.1"
  gem "factory_girl_rails", "~> 4.3.0"
  gem "faker", "~> 1.2.0"
  gem "database_cleaner", "~> 1.2.0" # Clear data for each spec run
  gem 'coveralls', '~> 0.7.0', require: false
end
