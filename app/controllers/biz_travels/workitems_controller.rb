module BizTravels


  class WorkitemsController < ApplicationController
    def index
      @workitems = RUOTE.storage_participant.all
      @user_id = session[:user_id].to_s()
    end
  
    def show
      if ( fei = Ruote::FlowExpressionId.from_id(params[:id]) )
        @workitem = RUOTE.storage_participant[fei]
      end
    end
  
    def edit
      if ( fei = Ruote::FlowExpressionId.from_id(params[:id]) )
        @workitem = RUOTE.storage_participant[fei]
      end
    end
  
    def user_workitems
      @workitems = RUOTE.storage_participant.all
      mygroups = session[:mygroups]
      if mygroups.nil?
        mygroups = set_my_groups(@workitems)
      end
      
      @workitems.keep_if {|wi| session[:user_id] == wi.fields['requestor_id'] and wi.participant_name == 'requestor' or mygroups.include? wi.participant_name }
    end  
  
    def user_workitems_count
      @workitems = user_workitems
      @count =  @workitems.nil? ? 0 : @workitems.length
      render :layout => 'workitems_count'
    end
  
  
  
    private
    
    def set_my_groups(workitems)
      workitems_process_names = []    
      if not workitems.nil?
        workitems.each do |w|
          workitems_process_names << w.wf_name  
        end  
      end
      ulgm =  UserLevelGroupMap.where("level = ? AND module_name IN (?)", session[:allpositions], workitems_process_names)
      groups = []
      if not ulgm.nil?
        ulgm.each do |u|
          groups << u.group_name   
        end
      end  
      session[:mygroups] = groups
      return groups
    end
    
  end

end