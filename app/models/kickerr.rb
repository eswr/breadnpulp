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
								length: { maximum: 150 }
end
