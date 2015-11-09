# == Schema Information
#
# Table name: food_alerts
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FoodAlert < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :food_items

	def FoodAlert.get_food_alerts
		food_alerts = {}
		FoodAlert.all.eager_load(:food_items, :user).each do |fa|
			if fa.food_items.present?
				food_alerts[fa.user_id] = []
				fa.food_items.each do |fi|
					food_alerts[fa.user_id] << fi
				end
			end
		end
		food_alerts
	end
end
