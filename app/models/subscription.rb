# == Schema Information
#
# Table name: subscriptions
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  at                :time
#  start_date        :date
#  address_id        :integer
#  veg_qty           :integer
#  egg_qty           :integer
#  non_veg_qty       :integer
#  payment_status_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  no_of_days        :integer
#

class Subscription < ActiveRecord::Base

	after_create	:set_payment_status
	after_create	:create_deliveries
	
	belongs_to 		:user
	has_many		:deliveries
	has_one			:payment_status

	private
		def create_deliveries
			for date in self.start_date..(self.start_date + ((self.no_of_days) - 1).day)
				self.deliveries.create(	delivery_date: date, at: self.at,
										user_id: self.user_id, address_id: self.address_id,
										delivery_status: DeliveryStatus.find_by(name: 'Confirmed'),
										payment_status_id: self.payment_status_id)
			end
		end

		def set_payment_status
			self.payment_status_id = PaymentStatus.first.id
			self.save
		end
end
