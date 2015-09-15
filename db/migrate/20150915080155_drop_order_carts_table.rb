class DropOrderCartsTable < ActiveRecord::Migration
  def change
  	drop_table :cart_menus
  	drop_table :carts
  end
end
