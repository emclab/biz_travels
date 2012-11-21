  # encoding: utf-8
module BizTravels  
  class BusinessTravel < ActiveRecord::Base
    belongs_to :user, :class_name => "Authentify::User"
    attr_accessible :wfid, :actual_cost, :customers_to_visit, :decision, :estimated_cost, :from_date, :to_date, :last_updated_by_id, :note, :purpose, :review_date, :state, :travel_summary, :type_of_transportation
  
  
  
     PDEF_BUSINESS_TRAVELS = Ruote.process_definition :name => 'business_travels', :revision => '0.1' do
      cursor do
        requestor :task => 'request_business_travel_application_form'
        sequence  do 
          participant 'approver', :task => 'approve_business_travel_application_form'
          participant 'ceo', :if => " ${f:requested_stipend}  > ${v:amount_supervised} and ( ${f:request_form_not_ok} is null or ${f:travel_rejected} is null ) ", :task => 'approve_business_travel_application_form'
        end
        cancel_process  :if => '${rejected_by_ceo}'
        cancel_process  :if => '${travel_rejected}' 
        rewind :if => '${request_form_not_ok}'
        cursor do
          requestor :task => 'business_travel_report_form'
          reviewer :task => 'review_business_travel_report_form'
          rewind :if => '${incomplete_report}'
        end
      end
    end
  
    
    state_machine :initial => :pending_request do
      event :approve_travel do
        transition any => :travel_approved
      end
      
      event :submit_request do
        transition :pending_request => :request_submitted
        transition :request_additional_info => :request_submitted
      end
      
      event :request_not_ok do
        transition any => :request_additional_info
      end
      
      event :reject_travel do
        transition any => :rejected_travel
      end
      
      event :approve_travel do
        transition any => :approved_travel
      end
      
      event :submit_report do
        transition :travel_approved => :report_submitted
        transition :report_rejected => :report_submitted
        transition :request_additional_info => :report_submitted
      end
      
      event :reject_report do
        transition :report_submitted => :report_rejected
      end
  
      event :approve_report do
        transition any => :report_approved
      end
      
      state :pending_request do
      end
      
      state :approved_travel do
      end
      
      state :rejected_travel do
      end
      
      state :request_additional_info do
      end
      
      state :report_rejected do
      end
  
      state :report_approved do
      end
    end
    
      
    def ruote_create_business_travel
      logger.debug("pdef = #{PDEF_BUSINESS_TRAVELS}")
      self.wfid = RuoteKit.engine.launch(PDEF_BUSINESS_TRAVELS, initial_workitem_fields={:object_type => :business_travel, :object_id => id, :requestor_id => user.id }, process_variables={'amount_supervised' => '0.01'}) 
      self.save
      logger.debug("=====> wfid=#{self.wfid}")
      return wfid
    end
    
  
    def name
      decision  
    end
  
  end
end