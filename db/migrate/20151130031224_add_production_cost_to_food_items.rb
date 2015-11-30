class AddProductionCostToFoodItems < ActiveRecord::Migration
  def change
  	add_column :food_items, :production_cost, :integer
  end
end
