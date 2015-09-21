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
#

class Address < ActiveRecord::Base
	belongs_to :user

	validates		:user_id,			presence: true
	validates		:name,				presence: true,
										length: { maximum: 20 }
	validates		:full_address,		presence: true,
										length: { maximum: 255 }

	VALID_PINCODE_REGEX = /\A[1-9]{1}\d{5}\z/
	validates 		:pincode,			presence: true,
										length: { is: 6 },
										format: { with: VALID_PINCODE_REGEX }

	def postal_address
		"#{full_address} - #{pincode}"
	end

end
