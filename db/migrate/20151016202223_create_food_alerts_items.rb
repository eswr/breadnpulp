class CreateFoodAlertsItems < ActiveRecord::Migration
  def change
    create_table :food_alerts_items, id: false do |t|
    	t.integer :food_item_id
    	t.integer :food_alert_id
    end

    add_index :food_alerts_items, :food_item_id
    add_index :food_alerts_items, :food_alert_id
  end
end
