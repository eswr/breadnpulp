# == Schema Information
#
# Table name: delivery_statuses
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class DeliveryStatus < ActiveRecord::Base

	has_many :deliveries

	validates :name, 	presence: true,
						uniqueness: { case_sensitive: false }

	def colorize
		if self.name = "Tentative"
			"pink"
		elsif self.name = "Confirmed"
			"green"
		elsif self.name = "Cancelled"
			"black"
		else
			"blue"
		end
	end
end
