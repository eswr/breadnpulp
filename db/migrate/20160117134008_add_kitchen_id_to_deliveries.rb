class AddKitchenIdToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :kitchen_id, :integer, default: 1

    Delivery.all.each do |delivery|
    	delivery.update_attribute :kitchen_id, 1
    end
  end
end
