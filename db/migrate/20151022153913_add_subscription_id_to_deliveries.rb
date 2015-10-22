class AddSubscriptionIdToDeliveries < ActiveRecord::Migration
  def change
  	add_column :deliveries, :subscription_id, :integer
  end
end
