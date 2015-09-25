class RenameShowInFoodItems < ActiveRecord::Migration
  def change
  	rename_column :food_items, :show?, :show
  end
end
