class AddPaymentStatusToDeliveries < ActiveRecord::Migration
  def change
  	add_column :deliveries, :payment_status_id, :integer
  end
end
