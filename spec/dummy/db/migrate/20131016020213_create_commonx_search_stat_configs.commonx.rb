# This migration comes from commonx (originally 20130827231304)
class CreateCommonxSearchStatConfigs < ActiveRecord::Migration
  def change
    create_table :commonx_search_stat_configs do |t|
      t.string :resource_name
      t.text :stat_function
      t.text :stat_summary_function
      t.text :labels_and_fields
      t.string :search_results_url
      t.text :search_where
      t.boolean :include_stats
      t.text :search_results_period_limit
      t.integer :last_updated_by_id
      t.timestamps
      t.string :brief_note
      
    end
    
    add_index :commonx_search_stat_configs, :resource_name
    add_index :commonx_search_stat_configs, :search_results_url
  end
end
