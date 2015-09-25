class AddPaymentCollectionToDeliveries < ActiveRecord::Migration
  def change
  	add_column :deliveries, :payment_date, :date
  	add_column :deliveries, :payment_mode, :string
  end
end
