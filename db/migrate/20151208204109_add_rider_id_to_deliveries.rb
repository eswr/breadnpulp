class AddRiderIdToDeliveries < ActiveRecord::Migration
  def change
  	add_column :deliveries, :rider_id, :integer
  end
end
