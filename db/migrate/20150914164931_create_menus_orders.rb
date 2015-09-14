class CreateMenusOrders < ActiveRecord::Migration
  def change
    create_table :menus_orders, id: false do |t|
    	t.integer :menu_id
    	t.integer :order_id
    end

    add_index :menus_orders, :menu_id
    add_index :menus_orders, :order_id
  end
end
