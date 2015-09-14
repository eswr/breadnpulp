class AddPriceToMenu < ActiveRecord::Migration
  def change
  	add_column :menus, :price, :integer
  end
end
