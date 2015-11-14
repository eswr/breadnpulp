class AddExpectedConsumptionToMenus < ActiveRecord::Migration
  def change
  	add_column :menus, :expected_consumption, :integer
  end
end
