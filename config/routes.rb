BizTravels::Engine.routes.draw do

  mount Authentify::Engine => "/authentify", :as => "authentify_engine"
  
  ########### START: Added this for rspec testing
  match '/user_menus', :to => 'authentify/user_menus#index'
  match '/signin',  :to => 'authentify/sessions#new'
  match '/signout', :to => 'authentify/sessions#destroy'
  ########### END:  Added this for rspec testing

  match '/_ruote' => RuoteKit::Application
  match '/_ruote/*path' => RuoteKit::Application

  #---- workitems list
  root :to => 'businessTravels#index'
  resources :workitems do
    member do
      get :user_workitems
      get :user_workitems_count
    end
  end
  
  match 'worklist' => 'worklist#index'

  #---- business travels routing instruction
  resources :business_travels do
    member do
      put :request_travel
      put :approve
      put :reject
      put :submit_report
      put :approve_travel
      put :reject_travel
      put :request_form_not_ok
      put :approve_report
      put :reject_report
      put :report_form_not_ok
      get :user_business_travels
      get :user_business_travels_count
    end      
  end  


end

