# This migration comes from authentify (originally 20130516153350)
class AddIndexEngineNameArgumentNameToAuthentifyEngineConfigs < ActiveRecord::Migration
  def self.up
    add_index :authentify_engine_configs, :argument_name
    add_index :authentify_engine_configs, :engine_name
  end
  
  def self.down
    remove_index :authentify_engine_configs, :column => :engine_name
    remove_index :authentify_engine_configs, :column => :argument_name
  end
end
