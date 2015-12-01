# == Schema Information
#
# Table name: packs
#
#  id          :integer          not null, primary key
#  quantity    :integer
#  menu_id     :integer
#  delivery_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  unit_price  :integer
#

class Pack < ActiveRecord::Base
	belongs_to :menu
	belongs_to :delivery
	belongs_to :kickerr

	after_create :check_coupons

	def get_unit_price
		unit_price || menu.get_price || "price not set"
	end

	def self.to_csv
		CSV.generate do |csv|
			csv << ["Quantity", "Menu id", "delivery id", "Price"]
			all.each do |pack|
				csv << [pack.quantity, pack.menu_id, pack.delivery_id, pack.unit_price]
			end
		end
	end

	def check_coupons
		if delivery.coupon_code?
			code = delivery.coupon_code.upcase
			coupon = Coupon.find_by(code: code, original_price: menu.price, active: true)
			if !coupon.nil?
				update_attribute :unit_price, coupon.final_price
			end
		end
	end
end
