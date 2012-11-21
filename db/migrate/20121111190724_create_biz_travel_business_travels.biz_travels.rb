# This migration comes from biz_travels (originally 20120813105538)
class CreateBizTravelBusinessTravels < ActiveRecord::Migration
  def change
    create_table :biz_travels_business_travels do |t|
      t.integer :user_id
      t.string :state
      t.datetime :from_date
      t.datetime :to_date
      t.text :purpose
      t.decimal :estimated_cost
      t.string :type_of_transportation
      t.decimal :actual_cost
      t.text :customers_to_visit
      t.text :note
      t.string :decision
      t.datetime :review_date
      t.text :travel_summary
      t.integer :last_updated_by_id
      t.string :wfid

      t.timestamps
    end
  end
end
