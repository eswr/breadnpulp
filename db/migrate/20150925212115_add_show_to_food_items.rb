class AddShowToFoodItems < ActiveRecord::Migration
  def change
  	add_column :food_items, :show, :boolean
  end
end
