module BizTravels

  class BusinessTravelsController < ApplicationController
    include Authentify::AuthentifyUtility
    include Commonx::CommonxHelper

    def index
      @business_travels = pending_business_travels
      #respond_to do |format|
      #  format.html # index.html.erb
      #  format.xml  { render :xml => @business_travels }
      #end
    end
  
    def show
      @business_travel = BusinessTravel.find(params[:id])
      @user_id = @business_travel.user.id.to_s()
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @business_travel }
      end
    end
  
    def new
      @business_travel = BusinessTravel.new
      @business_travel.user = Authentify::User.find(session[:user_id])
      @business_travel.last_updated_by_id = @business_travel.user.id
      @last_updated_by = @business_travel.user.name
      @user_id = @business_travel.user.id.to_s() 
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @business_travel }
      end
    end
  
    def edit
      @business_travel = BusinessTravel.find(params[:id])
      @last_updated_by = Authentify::User.find(@business_travel.last_updated_by_id).name
      @workitems = RUOTE.storage_participant.all
      @workitems.keep_if {|wi| wi.fields['object_id'] == @business_travel.id }
      @workitem = @workitems.first
      @user_id = @business_travel.user.id.to_s()
      @erb_code = find_ruote_config_for("#{@workitem.fields['params']['task']}", params[:controller].camelize.deconstantize.tableize.singularize.downcase)
    end
  
    def create
      @business_travel = BusinessTravel.new(params[:business_travel])
      @business_travel.user = Authentify::User.find(session[:user_id])
      @business_travel.last_updated_by_id = @business_travel.user.id
      @last_updated_by = @business_travel.user.name
      logger.info("create biz_travel 1")  
      respond_to do |format|
        if @business_travel.save!
          logger.info("create biz_travel 2")  
          #@wfid = @business_travel.ruote_create_business_travel
          @business_travel.wfid = ruote_create_business_travel(@business_travel)
          logger.info("create biz_travel 3")  
          @business_travel.save!
          logger.info("create biz_travel 4")  
          @wfid = @business_travel.wfid
          logger.info("create biz_travel 5")  
          delay_for_workitems(@wfid)
          logger.info("create biz_travel 6")  
          flash[:notice] = 'Business travel was successfully created.'
          format.html { redirect_to business_travels_path }
          format.xml  { render :xml => business_travels_path, :status => :created, :location => @business_travel }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @business_travel.errors, :status => :unprocessable_entity }
        end
      end
    end

    def ruote_create_business_travel(business_travel)
      engineName =  params[:controller].camelize.deconstantize.tableize.singularize.downcase
      process_definition = find_ruote_config_for('process_definition',engineName)
      logger.info("pdef = #{process_definition}")
      #wfid = RUOTE.launch(process_definition, initial_workitem_fields={:object_type => :business_travel, :object_id => business_travel.id, :requestor_id => business_travel.user.id }, process_variables={'amount_supervised' => '0.01'})
      workitem_fields = find_ruote_config_for('initial_workitem_fields', engineName)
      process_variables = find_ruote_config_for('process_variables', engineName)
      wfid = RUOTE.launch(process_definition, initial_workitem_fields=eval(workitem_fields), process_variables=eval(process_variables))
      logger.info("=====> wfid=#{wfid}")
      return wfid
    end

    def update
      @business_travel = BusinessTravel.find(params[:id])
      if ( fei = Ruote::FlowExpressionId.from_id(params[:business_travel][:fei_id]) )
        workitem = RUOTE.storage_participant[fei]
      end
  
      respond_to do |format|
        if @business_travel.update_attributes(params[:business_travel])
          RUOTE.storage_participant.proceed(workitem)
          flash[:notice] = 'Business travel was successfully updated.'
          #format.html { redirect_to(@business_travel) }
          format.html { redirect_to user_business_travels_business_travel_path, :id => session[:user_id] }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @business_travel.errors, :status => :unprocessable_entity }
        end
      end
    end
   
    def destroy
      @business_travel = BusinessTravel.find(params[:id])
      if @business_travel.destroy
        @workitems = RUOTE.storage_participant.all
        @workitems.keep_if {|wi| wi.fields['object_id'] == @business_travel.id }
        @workitem = @workitems.first
        RUOTE.engine.cancel_process(@workitem.wfid)
          respond_to do |format|
            format.html { redirect_to :action => "user_business_travels", :id => session[:user_id] }
            flash[:notice] = 'Business travel/workitem was successfully deleted.'
            format.json { head :no_content}
          end
      end
    end
     
    def request_travel
      @business_travel = BusinessTravel.find(params[:id])
      @updated_by = Authentify::User.find(session[:user_id])
      @business_travel.last_updated_by_id = @updated_by.id
      @last_updated_by = @updated_by.name
      if @business_travel.update_attributes(params[:business_travel])
        if ( fei = Ruote::FlowExpressionId.from_id(params[:business_travel][:fei_id]) )
          workitem = RUOTE.storage_participant[fei]
        end
        
        workitem.fields['requested_stipend'] = @business_travel.estimated_cost
        if @business_travel.submit_request
          workitem.fields.delete('request_form_not_ok')
          workitem.fields.delete('travel_rejected')
          RUOTE.storage_participant.proceed(workitem)
        end
        
        respond_to do |format|
        format.html { redirect_to business_travels_path }
        flash[:notice] = 'Business travel was officially submitted.'
        end
      end  
    end
  
    def approve_travel
       if params[:Approve_Travel]
         approve_travel_helper
       elsif params[:Reject_Travel] 
         reject_travel
       elsif params[:More_Info_Needed]
         request_form_not_ok   
       end
    end
    
    def approve_travel_helper
      @business_travel = BusinessTravel.find(params[:id])
      @updated_by = Authentify::User.find(session[:user_id])
      @business_travel.last_updated_by_id = @updated_by.id
      @last_updated_by = @updated_by.name
      
      if ( fei = Ruote::FlowExpressionId.from_id(params[:business_travel][:fei_id]) )
        workitem = RUOTE.storage_participant[fei]
      end
      if @business_travel.update_attributes(params[:business_travel])
        if @business_travel.approve_travel
          workitem.fields.delete('request_form_not_ok')
          workitem.fields.delete('travel_rejected')
          RUOTE.storage_participant.proceed(workitem)
        end
        respond_to do |format|
          format.html { redirect_to business_travels_path }
        end
      end  
    end
  
    def reject_travel
      @business_travel = BusinessTravel.find(params[:id])
      @updated_by = Authentify::User.find(session[:user_id])
      @business_travel.last_updated_by_id = @updated_by.id
      @last_updated_by = @updated_by.name
  
      if ( fei = Ruote::FlowExpressionId.from_id(params[:business_travel][:fei_id]) )
        workitem = RUOTE.storage_participant[fei]
      end
      
      if (workitem.participant_name == 'ceo')
        workitem.fields['rejected_by_ceo'] = true    
      end
      
      workitem.fields['travel_rejected'] = true
      if @business_travel.update_attributes(params[:business_travel])
        if @business_travel.reject_travel
          RUOTE.storage_participant.proceed(workitem)
        end
        
        respond_to do |format|
          format.html { redirect_to business_travels_path }
        end
      end  
    end
  
    def request_form_not_ok
      @business_travel = BusinessTravel.find(params[:id])
      @updated_by = Authentify::User.find(session[:user_id])
      @business_travel.last_updated_by_id = @updated_by.id
      @last_updated_by = @updated_by.name
  
      if ( fei = Ruote::FlowExpressionId.from_id(params[:business_travel][:fei_id]) )
        workitem = RUOTE.storage_participant[fei]
      end
  
      workitem.fields['request_form_not_ok'] = true
      
      respond_to do |format|
        if @business_travel.update_attributes(params[:business_travel])
          if @business_travel.request_not_ok
            RUOTE.storage_participant.proceed(workitem)
            flash[:notice] = 'Business travel was successfully updated.'
          end  
          format.html { redirect_to business_travels_path }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @business_travel.errors, :status => :unprocessable_entity }
        end
      end
    end
  
    def submit_report
      @business_travel = BusinessTravel.find(params[:id])
      @updated_by = Authentify::User.find(session[:user_id])
      @business_travel.last_updated_by_id = @updated_by.id
      @last_updated_by = @updated_by.name
  
      if @business_travel.update_attributes(params[:business_travel])
        if ( fei = Ruote::FlowExpressionId.from_id(params[:business_travel][:fei_id]) )
          workitem = RUOTE.storage_participant[fei]
        end
    
        if @business_travel.submit_report
          workitem.fields.delete('incomplete_report')
          RUOTE.storage_participant.proceed(workitem)
        end
        
        respond_to do |format|
          format.html { redirect_to business_travels_path }
        end
      end  
    end
  
    def approve_report
       if params[:Approve_Report]
         approve_report_helper
       elsif params[:Incomplete_Report] 
         reject_report
       end
    end
  
    def approve_report_helper
      @business_travel = BusinessTravel.find(params[:id])
      @updated_by = Authentify::User.find(session[:user_id])
      @business_travel.last_updated_by_id = @updated_by.id
      @last_updated_by = @updated_by.name
  
      if ( fei = Ruote::FlowExpressionId.from_id(params[:business_travel][:fei_id]) )
        workitem = RUOTE.storage_participant[fei]
      end
      if @business_travel.update_attributes(params[:business_travel])
        if @business_travel.approve_report
          RUOTE.storage_participant.proceed(workitem)
        end
        
        respond_to do |format|
          format.html { redirect_to business_travels_path }
        end
      end  
    end
  
    def reject_report
      @business_travel = BusinessTravel.find(params[:id])
      @updated_by = Authentify::User.find(session[:user_id])
      @business_travel.last_updated_by_id = @updated_by.id
      @last_updated_by = @updated_by.name
  
      if ( fei = Ruote::FlowExpressionId.from_id(params[:business_travel][:fei_id]) )
        workitem = RUOTE.storage_participant[fei]
      end
      if @business_travel.update_attributes(params[:business_travel])
        if @business_travel.reject_report
          workitem.fields['incomplete_report'] = true
          RUOTE.storage_participant.proceed(workitem)
        end
        
        respond_to do |format|
          format.html { redirect_to business_travels_path }
        end
      end  
    end
  
    def user_business_travels
      @BusinessTravels = pending_business_travels
      return @BusinessTravels
   end  
  
    def user_business_travels_count
      @BusinessTravels = pending_business_travels
      @count =  @BusinessTravels.nil? ? 0 : @BusinessTravels.length
      render :layout => 'business_travels_count'
    end
  
  
  
    def pending_business_travels
      @workitems = RUOTE.storage_participant.all
      mygroups = session[:mygroups]
      if mygroups.nil?
        #mygroups = set_my_groups(@workitems)
        mygroups = set_my_groups(params['controller'].split('/')[-1])
      end
      @workitems.keep_if {|wi| session[:user_id] == wi.fields['requestor_id'] and wi.participant_name == 'requestor' or mygroups.include? wi.participant_name }
      ids = []
      @workitems.each do |wi|
        anId = wi.fields['object_id']
        ids << anId 
      end  
      @user_id = session[:user_id].to_s()
      @business_travels = BusinessTravel.find(:all, :conditions => ["id IN (?)", ids])
    end  
  
    def user_business_travels_count
      @workitems = user_business_travels
      @count =  @workitems.nil? ? 0 : @workitems.length
      render :layout => 'workitems_count'
    end

=begin
    def set_my_groups(workitems)
      workitems_process_names = []    
      if not workitems.nil?
        workitems.each do |w|
          workitems_process_names << w.wf_name 
        end  
      end

      @user = Authentify::User.find(session[:user_id])
      up = session[:user_privilege]
      groups = up.find_user_module_groups(workitems_process_names[0])
      session[:mygroups] = groups
      return groups
    end
=end
    def set_my_groups(moduleName)
      @user = Authentify::User.find(session[:user_id])
      up = session[:user_privilege]
      groups = up.find_user_module_groups(moduleName)
      session[:mygroups] = groups
      return groups
    end

    
    def set_my_groups1(workitems)
      @user = Authentify::User.find(session[:user_id])
      user_all_levels_names = []    
      @user.user_levels.each do |ul|
        user_all_levels_names << ul.position
      end
  
      workitems_process_names = []    
      if not workitems.nil?
        workitems.each do |w|
          workitems_process_names << w.wf_name 
        end  
      end
      ulgm =  Authentify::UserLevelGroupMap.where("level = ? AND module_name IN (?)", user_all_levels_names, workitems_process_names)
      groups = []
      if not ulgm.nil?
        ulgm.each do |u|
          groups << u.group_name  
        end
      end  
      session[:mygroups] = groups
      return groups
    end
  
    
    def delay_for_workitems(wfid)
      300.times do 
        sleep 0.010 # 3 seconds max 
        @workitems = RUOTE.storage_participant.all 
        break if @workitems.find { |wi| wi.wfid == wfid } 
      end 
    end
  
  end
  

  
  
end