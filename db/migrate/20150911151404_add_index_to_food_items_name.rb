class AddIndexToFoodItemsName < ActiveRecord::Migration
  def change
    add_index :food_items, :name, unique: true
  end
end
