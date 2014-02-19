ENV["RAILS_ENV"] ||= 'test'

require 'coveralls'
Coveralls.wear!('rails')

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'factory_girl'

# Run Sidekiq with a test fake that pushes all jobs into a jobs array
require 'sidekiq/testing'
Sidekiq::Testing.fake!

# Requires supporting ruby files with custom matchers and macros, etc
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActionMailer::Base.delivery_method = :test

RSpec.configure do |config|
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end

def login_user(user)
  cookies[:auth_token] = user.auth_token
end

def logout!
  cookies.delete(:auth_token)
end

class ActiveRecord::Base
  class << self

    # Wrapper for FactoryGirl.create
    def make!(*args, &block)
      object = FactoryGirl.create(name.underscore, *args)
      yield object if block_given?
      object
    end

  end
end
