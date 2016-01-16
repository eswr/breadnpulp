class AddDefaultToDeliveryStatusInDeliveries < ActiveRecord::Migration
  def change
  	change_column :deliveries, :delivery_status_id, :integer, default: 1
  end
end
