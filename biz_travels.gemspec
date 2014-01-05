$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "biz_travels/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "biz_travels"
  s.version     = BizTravels::VERSION
  s.authors     = ["Biz NetCloud"]
  s.email       = ["support@emclab.com"]
  s.homepage    = "http://biznetcloud.com"
  s.summary     = "biz_travels-#{s.version} manages business travels requests as a workflow that include different actors /
                   to approve, review such request and finally approve or reject it."
  s.description = "A Rails app that manages corporate business travels"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "3.2.12"
  s.add_dependency "sqlite3"
  s.add_dependency "database_cleaner"

  s.add_dependency "simple_form"
  s.add_dependency 'will_paginate', '~> 3.0'
  s.add_dependency 'jquery-rails' #, '~>2.0.0'
  s.add_dependency "database_cleaner"
  #s.add_dependency "rufus-scheduler"
  s.add_dependency "gon"
  s.add_dependency 'execjs'
  
  #s.add_dependency 'therubyracer'
  s.add_dependency 'sass-rails',   '~> 3.2.3'
  s.add_dependency 'coffee-rails', '~> 3.2.1'
  s.add_dependency 'uglifier', '>= 1.0.3'
  #s.add_dependency 'bootstrap-sass', '~> 2.3.1.0'
  #s.add_dependency 'bootstrap-sass', '~> 2.0.4.0'
  s.add_dependency 'yajl-ruby' #, :require => 'yajl'
  s.add_dependency 'ruote-sequel'
  
  s.add_dependency "thin", "1.3.1"
  #s.add_dependency "eventmachine", "1.0.0.beta.4.1"
  
  s.add_dependency 'haml-rails'
  s.add_dependency 'sinatra', '~>1.2'
  s.add_dependency 'sinatra-respond_to'
  s.add_dependency 'ruote' #, '~>2.3.0'  #:git => 'http://github.com/jmettraux/ruote.git'
  #s.add_dependency 'ruote-kit' #, '~>2.3.0'  # :git => 'http://github.com/tosch/ruote-kit.git'
  s.add_dependency 'bcrypt-ruby'
  s.add_dependency 'state_machine'


  #s.add_development_dependency "authentify"
 # s.add_development_dependency "commonx"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency 'factory_girl_rails', '~> 3.0'

end

