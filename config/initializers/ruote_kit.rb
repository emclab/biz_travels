#AMQP.settings[:host] = Settings.amqp.host


require 'yajl'
#Rufus::Json.backend = :yajl

require 'ruote/storage/fs_storage'

RUOTE_STORAGE = Ruote::FsStorage.new("ruote_work_#{Rails.env}")

RuoteKit.engine = Ruote::Engine.new(Ruote::Worker.new(RUOTE_STORAGE))

#RuoteAMQP::Receiver.new( RuoteKit.engine )

# By default, there is a running worker when you start the Rails server. That is
# convenient in development, but may be (or not) a problem in deployment.
#
# Please keep in mind that there should always be a running worker or schedules
# may get triggered to late. Some deployments (like Passenger) won't guarantee
# the Rails server process is running all the time, so that there's no always-on
# worker. Also beware that the Ruote::HashStorage only supports one worker.
#
# If you don't want to start a worker thread within your Rails server process,
# replace the line before this comment with the following:
#
# RuoteKit.engine = Ruote::Engine.new(RUOTE_STORAGE)
#
# To run a worker in its own process, there's a rake task available:
#
#     rake ruote:run_worker
#
# Stop the task by pressing Ctrl+C



require 'ruote/part/smtp_participant'


# make changes if needed
#
# config.work_directory = 'my_special_work_dir' # defaults to File.join( Dir.pwd, "work_#{RuoteKit.env}" )
# config.workers = 2                            # defaults to 1
# config.run_worker = true                      # defaults to false
# config.mode = :transient                      # defaults to :file_system


unless $RAKE_TASK
  # don't register participants when the run is triggered by a rake task

  RuoteKit.engine.register do

    # register your own participants using the participant method
    #
    # Example:
    # participant 'alice', Ruote::StorageParticipant
    #RuoteAMQP::Receiver.new( RuoteKit.engine )  
    participant :requestor_notification, Ruote::SmtpParticipant,
                :server => 'smtp.gmail.com',
                :port => 587,
                :to => 'achouicha@gmail.com',
                :from => 'noreply@somewhere.com',
                :notification => true,
                :template => "Subject: ${f:email_subject}\n\ntest email"
                
    # Requestor must submit account app and NDA forms
    participant :requestor, Ruote::StorageParticipant
    
    # Reviewer must make sure account app and NDA forms are completely filled out
    participant :reviewer, Ruote::StorageParticipant
  
    # Approver has final say over whether or not account is created
    participant :approver, Ruote::StorageParticipant

    # CEO participant
    participant 'ceo', Ruote::StorageParticipant
  
    # Let's try the stateless, or 'by-class' way
    participant :ashley, Ruote::StorageParticipant #RuoteAMQP::Participant
    participant :kitty, Ruote::StorageParticipant  #RuoteAMQP::Participant
    participant :copper, Ruote::StorageParticipant #RuoteAMQP::Participant
    
    #RuoteAMQP::WorkitemListener.new( RuoteKit.engine )
    
    ##
    # This is the stateful, or 'by-instance' way, which doesn't work with
    # the current version of ruote-amqp and ruote 2.1:
    # amqp = RuoteAMQP::Participant.new(:default_queue => 'work1')
    # 
    # # Ingress mail servers are named ashley and kitty
    # amqp.map_participant('ashley', 'ingress_work1')
    # amqp.map_participant('kitty', 'ingress_work1')
    # 
    # # Mailbox server is copper
    # amqp.map_participant('copper', 'mailbox_work1')
    # 
    # participant :ashley, amqp
    # participant :kitty, amqp
    # 
    # participant :copper, amqp
    
    # register the catchall storage participant named '.+'
    catchall
  end    
end
