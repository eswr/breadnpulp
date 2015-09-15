class DropCartStatusesTable < ActiveRecord::Migration
  def change
  	drop_table :cart_statuses
  end
end
