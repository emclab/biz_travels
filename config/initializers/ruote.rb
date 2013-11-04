require 'rubygems'
require 'json' # gem install json
require 'ruote'
require 'ruote-sequel' # gem install ruote-sequel
 
#
# set up ruote storage
sequel = Sequel.connect('sqlite://db/development.sqlite3') if Rails.env.development?
sequel = Sequel.connect('sqlite://db/test.sqlite3') if Rails.env.test?
sequel = Sequel.connect('sqlite://db/production.sqlite3') if Rails.env.production?
#sequel = Sequel.connect('sqlite://db/ruote.sqlite3')

#ruote_docs is hte table name
opts = { 'sequel_table_name' => 'ruote_docs' }
#create ruote_docs table if it is not existing
Ruote::Sequel.create_table(sequel, false, 'ruote_docs') unless sequel.table_exists? 'ruote_docs'
RUOTE_STORAGE = Ruote::Sequel::Storage.new(sequel, opts)

# set up ruote dashboard and run ruote worker outside of rails app
RUOTE = Ruote::Dashboard.new(RUOTE_STORAGE)

require 'ruote/part/smtp_participant'


unless $RAKE_TASK
  # don't register participants when the run is triggered by a rake task

  #RuoteKit.engine.register do
  RUOTE.register do 

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



#RUOTE = if defined?(Rake)
  #
  # do not start a ruote worker in a rake task
  #
#  Ruote::Dashboard.new(RUOTE_STORAGE)
#else
  #
  # start a worker
  #
#  Ruote::Dashboard.new(Ruote::Worker.new(RUOTE_STORAGE))
#end

#
# participant registration
 
#RUOTE.register do
#  participant 'notifier', Acme::Participants::Notifier
#  participant /user_.+/, Ruote::StorageParticipant
#end
