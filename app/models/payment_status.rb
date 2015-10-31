# == Schema Information
#
# Table name: payment_statuses
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PaymentStatus < ActiveRecord::Base
	has_many :deliveries

	validates :name, 	presence: true,
						uniqueness: { case_sensitive: false }

	def colorize
		if self.name == "Payment Due"
			"red"
		elsif self.name == "Payment Complete"
			"green"
		else
			"blue"
		end
	end
end
