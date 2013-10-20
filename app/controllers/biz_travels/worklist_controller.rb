module BizTravels


  class WorklistController < ActionController::Base 
    def index
      @workitems = RUOTE.storage_participant.all
    end 
  end
  

end