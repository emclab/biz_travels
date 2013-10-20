class UserMenusController < ApplicationController
  before_filter :require_signin
  #before_filter :company_info

  #def company_info
  #  @company_logo_name = company_logo_name()
  #end


  def index  
    #set session vars for viewing history
    session[:page_step] = 1
    session[:page1] = user_menus_path
    render 'user_menus/index'
  end 
end
