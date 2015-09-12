# == Schema Information
#
# Table name: food_items
#
#  id          :integer          not null, primary key
#  name        :string
#  course      :string
#  veg_non_egg :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class FoodItem < ActiveRecord::Base

	validates	:name,			presence: true,
								uniqueness: true,
								length: { maximum: 50 }

	validates	:course,		presence: true,
								length: { maximum: 20 }

	validates	:veg_non_egg,	presence: true,
								length: { maximum: 20 }

	validates	:description,	presence: true,
								length: { maximum: 255 }

	has_attached_file :image,	styles: { medium: "300x300" }
	validates_attachment_content_type :image, 	content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]
						
end
