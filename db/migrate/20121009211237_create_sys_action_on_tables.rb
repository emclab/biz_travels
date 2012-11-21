class CreateSysActionOnTables < ActiveRecord::Migration
  def change
    create_table :authentify_sys_action_on_tables do |t|
      t.string :action
      t.string :table_name

      t.timestamps
    end
  end
end
