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
end
