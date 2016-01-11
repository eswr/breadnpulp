# == Schema Information
#
# Table name: addresses
#
#  id           :integer          not null, primary key
#  name         :string
#  full_address :text
#  pincode      :string
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  locality     :string
#  city         :string
#

class Address < ActiveRecord::Base

	before_validation :get_full_address

	belongs_to :user
	has_many :deliveries

	attr_accessor :address_line_1, :address_line_2

	validates		:user_id,			presence: true
	validates		:name,				presence: true,
										length: { maximum: 20 }
	validates		:full_address,		presence: true,
										length: { maximum: 255 }

	VALID_PINCODE_REGEX = /\A[1-9]{1}\d{5}\z/
	validates 		:pincode,			presence: true,
										length: { is: 6 },
										format: { with: VALID_PINCODE_REGEX }

	validates		:locality,			presence: true
	validates		:city,				presence: true

	def postal_address
		"#{name}: #{full_address}, #{locality}, #{city} - #{pincode}"
	end

	def self.to_csv
		CSV.generate do |csv|
			csv << ["Id", "Name", "Full Address", "Pincode"]
			all.each do |address|
				csv << [address.id, address.name, address.full_address, address.pincode]
			end
		end
	end

	private
		def get_full_address
			self.full_address = address_line_1 + ", " + address_line_2
		end

end
