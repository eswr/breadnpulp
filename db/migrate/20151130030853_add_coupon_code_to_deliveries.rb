class AddCouponCodeToDeliveries < ActiveRecord::Migration
  def change
  	add_column :deliveries, :coupon_code, :string
  end
end
