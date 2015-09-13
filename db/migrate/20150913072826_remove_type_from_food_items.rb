class RemoveTypeFromFoodItems < ActiveRecord::Migration
  def change
  	remove_column :food_items, :type, :string
  	add_column :food_items, :course, :string
  end
end
