# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../dummy/config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require "factory_girl_rails"
require 'factory_girl'
require 'authentify'

ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')

FactoryGirl.definition_file_paths << File.join(File.dirname(__FILE__), 'factories')
FactoryGirl.find_definitions


# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(ENGINE_RAILS_ROOT, 'spec/support/**/*.rb')].each {|f| require f }


# Requires to support Ruote-Kit custom functions
#SPEC_ROOT = File.expand_path('..', __FILE__) unless defined?(SPEC_ROOT)
#require File.join(SPEC_ROOT, '../lib/ruote-kit')
#Dir[File.join(SPEC_ROOT, 'support/**/*.rb')].each { |f| require(f) }
#C:\apps\RailsInstaller\Ruby1.9.3\lib\ruby\gems\1.9.1\gems\ruote-kit-2.2.0.3\spec\support


RSpec.configure do |config|
  config.before(:each, type: :controller) { 
    @routes = BizTravels::Engine.routes
    #@routes = Authentify::Engine.routes
  }
  
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{ENGINE_RAILS_ROOT}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Include Engine routes (needed for Controller specs)
  config.include BizTravels::Engine.routes.url_helpers
  
  
  RuoteKit::Application.included_modules.each do |klass|
    config.include(klass) if klass.name =~ /RuoteKit::Helpers::\w+Helpers/
  end  
  
end