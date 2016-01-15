class AddDefaultValueToDeliveryStatusInDeliveries < ActiveRecord::Migration
  def change
  	change_column :deliveries, :delivery_status_id, :integer, defalut: 1
  end
end
