class RemoveCourseFromFoodItems < ActiveRecord::Migration
  def change
  	remove_column :food_items, :course, :string
  end
end
