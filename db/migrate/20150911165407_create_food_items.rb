class CreateFoodItems < ActiveRecord::Migration
  def change
    create_table :food_items do |t|
      t.string :name
      t.string :course
      t.string :veg_non_egg
      t.text :description

      t.timestamps null: false
    end
  end
end
