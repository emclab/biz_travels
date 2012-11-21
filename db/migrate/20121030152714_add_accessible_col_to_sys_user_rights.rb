class AddAccessibleColToSysUserRights < ActiveRecord::Migration
  def change
    add_column :authentify_sys_user_rights, :accessible_col, :string
  end
end
