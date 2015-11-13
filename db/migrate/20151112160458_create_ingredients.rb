class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.integer :raw_material_id
      t.integer :food_item_id
      t.float	:quantity
      t.string	:unit

      t.timestamps null: false
    end
  end
end
