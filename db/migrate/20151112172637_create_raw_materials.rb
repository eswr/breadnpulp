class CreateRawMaterials < ActiveRecord::Migration
  def change
    create_table :raw_materials do |t|
      t.string :name
      t.string :veg_non_egg

      t.timestamps null: false
    end
  end
end
