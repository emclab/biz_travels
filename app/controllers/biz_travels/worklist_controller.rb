module BizTravels


  class WorklistController < ActionController::Base 
    def index
      @workitems = RuoteKit.storage_participant.all
    end 
  end
  

end