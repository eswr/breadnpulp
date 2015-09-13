class CreateFoodItemsKickerrs < ActiveRecord::Migration
  def change
    create_table :food_items_kickerrs, id: false do |t|
    	t.integer :food_item_id
    	t.integer :kickerr_id
    end

    add_index :food_items_kickerrs, :food_item_id
    add_index :food_items_kickerrs, :kickerr_id
  end
end
