module BizTravels
  class Engine < ::Rails::Engine
    isolate_namespace BizTravels
    #initializer "BizTravel precompile hook", :group => :all do |app|
      #app.config.assets.precompile += [
     #   'biz_travels/application.css.scss', 'biz_travels/layout.css.scss', 'biz_travels/login.css.scss', 
     #   'biz_travels/paginate.css.scss', 'biz_travels/sessions.css.scss', 'biz_travels/sys_logs.css.scss', 
     #   'biz_travels/toolbar.css.scss', 'biz_travels/user_level_group_map.css', 'biz_travels/user_menus.css.scss', 
     #   'biz_travels/users.css.scss', 'biz_travels/application.js', 'biz_travels/sessions.js.coffee', 
     #   'biz_travels/sys_logs.js.coffee', 'biz_travels/user_level_group_map.js', 'biz_travels/user_menus.js.coffee', 
     #   'biz_travels/users.js']
   # end
    
    
    config.generators do |g|
      g.template_engine :erb
      g.integration_tool :rspec
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, :dir => "spec/factories"  
    end         
    
  end
  
  
end


