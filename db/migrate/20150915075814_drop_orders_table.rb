class DropOrdersTable < ActiveRecord::Migration
  def change
  	drop_table :menus_orders
  	drop_table :orders
  end
end
