# encoding: utf-8
module BizTravels  
  class BusinessTravel < ActiveRecord::Base
    belongs_to :user, :class_name => "Authentify::User"
    attr_accessible :wfid, :actual_cost, :customers_to_visit, :decision, :estimated_cost, :from_date, :to_date, :last_updated_by_id, :note, :purpose, :review_date, :state, :travel_summary, :type_of_transportation
  
    stat_machine = Commonx::CommonxHelper.find_ruote_config_for('state_machine','biz_travel')
    eval(stat_machine)
    
=begin  
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
=end    
  
    def name
      decision  
    end
  
  end
end