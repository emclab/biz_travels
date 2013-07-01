Rails.application.routes.draw do

  mount Authentify::Engine => "/authentify", :as => :authentify
  mount BizTravels::Engine => "/biz_travels"
  
  root :to => 'authentify::sessions#new'
  match '/user_menus', :to => 'authentify/user_menus#index'
  match '/signin',  :to => 'authentify/sessions#new'
  match '/signout', :to => 'authentify/sessions#destroy'
  
  
end
