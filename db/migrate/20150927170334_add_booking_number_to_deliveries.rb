class AddBookingNumberToDeliveries < ActiveRecord::Migration
  def change
  	add_column :deliveries, :booking_no, :string
  end
end
