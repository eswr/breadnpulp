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

end
