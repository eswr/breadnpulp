class AddSubscriptionIdToDeliveries < ActiveRecord::Migration
  def change
  	remove_column :deliveries, :subscription_id, :integer
  	add_column :deliveries, :subscription_id, :integer
  end
end
