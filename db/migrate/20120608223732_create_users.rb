class CreateUsers < ActiveRecord::Migration
  def change
    create_table :authentify_users do |t|
      t.string :name
      t.string :email
      t.string :login
      t.string :encrypted_password
      t.string :salt
      t.string :status, :default => 'active'
      t.integer :last_updated_by_id
      t.integer :customer_id
      t.timestamps
    end
  end
end
