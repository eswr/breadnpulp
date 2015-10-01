# == Schema Information
#
# Table name: kickerrs
#
#  id          :integer          not null, primary key
#  name        :string
#  price       :integer
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  veg_type    :string
#

class Kickerr < ActiveRecord::Base

	has_and_belongs_to_many :food_items

	has_many :menus

	has_many :packs, through: :menus

	validates :name,			presence: true,
								uniqueness: { case_sensitive: false }
	validates :price,			presence: true,
								numericality: true

	validates :description,		presence: true,
								length: { maximum: 200 }

	def colorize
		if self.veg_type == "Non-Veg"
			"red"
		elsif self.veg_type == "Egg"
			"#fed136"
		else
			"green"
		end
	end

	def set_veg_type
		veg_non_eggs = self.food_items.map { |fi| fi.veg_non_egg }
		if "Non-Veg".in?(veg_non_eggs)
			self.veg_type = "Non-Veg"
		elsif "Egg".in?(veg_non_eggs)
			self.veg_type = "Egg"
		else
			self.veg_type = "Veg"
		end
		self.save
	end
			
end
