# encoding: utf-8

require 'spec_helper'
#require 'application_controller.rb'

class Tracer
  def initialize
    @trace = '' 
  end
  def to_s
    @trace.to_s.strip
  end
  def << s
    @trace << s
  end
  def clear
    @trace = ''
  end
  def puts s
    @trace << "#{s}\n"
  end
end




describe BizTravels::BusinessTravelsController do
  before(:each) do
    #@routes = BizTravels::Engine.routes
    #@routes = Authentify::Engine.routes
    
    
    #controller.should_receive(:require_signin)   #error if commented out. Not sure why
    #controller.should_receive(:require_signin)
    #prepare_engine
    RuoteKit.engine = Ruote::Engine.new(Ruote::Worker.new(Ruote::HashStorage.new))
    @tracer = Tracer.new
    RuoteKit.engine.add_service('tracer', @tracer)
    RuoteKit.engine.register do
      catchall Ruote::StorageParticipant
    end
  end
    
  after(:each) do
    return unless RuoteKit.engine
    RuoteKit.engine.shutdown
    RuoteKit.engine.storage.purge!
    RuoteKit.engine = nil
  end    
    
  
  render_views

  describe "GET #index" do
    it "returns http success" do 
      session[:admin] = true
      session[:user_id] = 1
      
      user_group = FactoryGirl.create(:sys_user_group, :user_group_name => 'admin')
      ul = FactoryGirl.create(:user_level, :user_id => 1, :sys_user_group_id => user_group.id)
      u = FactoryGirl.create(:user, :user_levels => [ul])
      session[:user_privilege] = Authentify::UserPrivilege.new(u.id)    
      b = FactoryGirl.create(:business_travel) 
      get 'index'
      response.should render_template :index
    end
  end

  describe "GET #show" do
    it "assigns the requested biz-travel to @biz_travel" do
      session[:user_id] = 1
      ul = FactoryGirl.create(:user_level)
      u = FactoryGirl.create(:user, :user_levels => [ul])

      biz_travel = FactoryGirl.create(:business_travel) 
      #get :show, id: biz_travel
      get :show, {:id => biz_travel, :use_route => :biz_travels}
      assigns(:business_travel).should eq(biz_travel)
    end
  
    it "renders the #show view" do
      session[:admin] = true
      session[:user_id] = 1
      ul = FactoryGirl.create(:user_level)
      u = FactoryGirl.create(:user, :user_levels => [ul])
      biz_travel = FactoryGirl.create(:business_travel)
      get :show, id: biz_travel
      response.should render_template :show
    end
  end
  

  describe "GET #new" do
    it "assigns a user to the new biz_travels" do
      #ul = FactoryGirl.create(:user_level)
      user_group = FactoryGirl.create(:sys_user_group, :user_group_name => 'admin')
      ul = FactoryGirl.create(:user_level, :user_id => 1, :sys_user_group_id => user_group.id)
      u = FactoryGirl.create(:user, :user_levels => [ul])
      session[:user_id] = u.id
      get :new
      assigns(:business_travel).last_updated_by_id.should eq u.id
    end
  end   

  describe "GET #edit" do
    it "assigns the requested biz-travel to @biz_travel" do
      #ul = FactoryGirl.create(:user_level)
      user_group = FactoryGirl.create(:sys_user_group, :user_group_name => 'admin')
      ul = FactoryGirl.create(:user_level, :user_id => 1, :sys_user_group_id => user_group.id)
      u = FactoryGirl.create(:user, :user_levels => [ul])
      session[:user_id] = u.id
      biz_travel = FactoryGirl.create(:business_travel) 
      @wfid = biz_travel.ruote_create_business_travel
      RuoteKit.engine.wait_for(2)
      @wi = RuoteKit.engine.storage_participant.first 
      get :edit, :id => biz_travel.id, :participant_name => 'ceo'
      assigns(:business_travel).should eq(biz_travel)
    end

  end
  



end
