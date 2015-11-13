# == Schema Information
#
# Table name: food_items
#
#  id                 :integer          not null, primary key
#  name               :string
#  veg_non_egg        :string
#  description        :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  course             :string
#  show_image         :boolean
#

class FoodItem < ActiveRecord::Base

	validates	:name,			presence: true,
								uniqueness: true,
								length: { maximum: 50 }

	validates	:course,		presence: true,
								length: { maximum: 20 }

	validates	:veg_non_egg,	presence: true,
								length: { maximum: 20 }

	validates	:description,	length: { maximum: 255 }

	has_attached_file :image,	styles: { medium: "300x300", thumb: "100x100" }
	validates_attachment_content_type :image, 	content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]

	has_and_belongs_to_many :kickerrs
	has_and_belongs_to_many :food_alerts
	has_many 				:ingredients

	accepts_nested_attributes_for :ingredients, reject_if: lambda { |attributes| attributes[:quantity] == "" },
                                        allow_destroy: true

	def colorize
		if self.veg_non_egg == "Non-Veg"
			"red"
		elsif self.veg_non_egg == "Egg"
			"#fed136"
		else
			"green"
		end
	end
end
