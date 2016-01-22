# == Schema Information
#
# Table name: menus
#
#  id                   :integer          not null, primary key
#  available_on         :date
#  kickerr_id           :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  price                :integer
#  expected_consumption :integer
#

class Menu < ActiveRecord::Base
  belongs_to :kickerr

  has_many :packs

  has_many :deliveries, through: :packs

  validates :available_on, 			presence: true
  validates :kickerr_id,			presence: true
  validates :price,					presence: true

  attr_accessor :kickerr_name

  def get_price
  	self.price.nil? ? self.kickerr.price : self.price
  end

	def self.to_csv
		CSV.generate do |csv|
			csv << ["Id", "Kickerr name", "Price", "Date", "Main course"]
			all.each do |menu|
				csv << [menu.id, menu.kickerr.name, menu.price, menu.available_on, menu.kickerr.food_items.where(course: 'Main').first.name]
			end
		end
	end

  def get_kickerr_name
    kickerr.name
  end

  def Menu.get_raw_material_requirement(date)
    menus = Menu.where(available_on: date).eager_load(kickerr: :food_items)
    requirements = {}
    menus.each do |menu|
      menu.kickerr.food_items.each do |food_item|
        food_item.ingredients.each do |ingredient|
          if requirements[:"#{ingredient.raw_material.name} (in #{ingredient.unit})"].nil?
            requirements[:"#{ingredient.raw_material.name} (in #{ingredient.unit})"] = ingredient.quantity * menu.expected_consumption
          else
            requirements[:"#{ingredient.raw_material.name} (in #{ingredient.unit})"] += ingredient.quantity * menu.expected_consumption
          end
        end
      end
    end
    requirements
  end
end
