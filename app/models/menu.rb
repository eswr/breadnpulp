# == Schema Information
#
# Table name: menus
#
#  id           :integer          not null, primary key
#  available_on :date
#  kickerr_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  price        :integer
#

class Menu < ActiveRecord::Base
  belongs_to :kickerr

  has_many :packs

  has_many :deliveries, through: :packs

  validates :available_on, 			presence: true
  validates :kickerr_id,			presence: true
  validates :price,					presence: true

  def get_price
  	self.price.nil? ? self.kickerr.price : self.price
  end

	def self.to_csv
		CSV.generate do |csv|
			csv << ["Id", "Kickerr name", "Price"]
			all.each do |menu|
				csv << [menu.id, menu.kickerr.name, menu.price]
			end
		end
	end
end
