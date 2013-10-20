require "biz_travels/engine"

require 'rails'
require 'jquery-rails'
require 'bootstrap-sass'
require 'biz_travels'

require "sqlite3"
require "database_cleaner"

require "simple_form"
require 'will_paginate'
require "rufus-scheduler"
require "gon"
require 'execjs'
  #s.add_dependency 'therubyracer'
require 'sass-rails'
require 'coffee-rails'
require 'uglifier'
#require 'yajl-ruby'
  
require "thin"
require "eventmachine"
  
require 'haml-rails'
require 'sinatra'
#require 'sinatra-respond_to'
require 'ruote' #, :git => 'http://github.com/jmettraux/ruote.git'
#require 'ruote-kit' #, :git => 'http://github.com/tosch/ruote-kit.git'
#require 'bcrypt-ruby'
require 'state_machine'


module BizTravels
  class Engine < ::Rails::Engine
    isolate_namespace BizTravels
    initializer "BizTravel precompile hook", :group => :all do |app|
      app.config.assets.precompile += [
        'biz_travels/application.css.scss', 'biz_travels/layout.css.scss', 'biz_travels/login.css.scss', 
        'biz_travels/paginate.css.scss', 'biz_travels/sessions.css.scss', 'biz_travels/sys_logs.css.scss', 
        'biz_travels/toolbar.css.scss', 'biz_travels/user_level_group_map.css', 'biz_travels/user_menus.css.scss', 
        'biz_travels/users.css.scss', 'biz_travels/application.js', 'biz_travels/sessions.js.coffee', 
        'biz_travels/sys_logs.js.coffee', 'biz_travels/user_level_group_map.js', 'biz_travels/user_menus.js.coffee', 
        'biz_travels/users.js']
    end
    
    
    config.generators do |g|                                                               
      g.test_framework :rspec
      g.integration_tool :rspec
    end
    
    
  end
  
  
end


