class User < ActiveRecord::Base

	before_save { self.email = email.downcase }

	validates :name, 					presence: true,
										length: { maximum: 50 }

	VALID_PHONE_NUMBER_REGEX = /\A[1-9]{1}\d{9}\z/
	validates :phone_number, 			presence: true,
										length: { maximum: 255 },
										format: { with: VALID_PHONE_NUMBER_REGEX },
										uniqueness: true
	
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, 					presence: true,
										length: { is: 10 },
										format: { with: VALID_EMAIL_REGEX },
										uniqueness: { case_sensitive: false }

	has_secure_password
	validates :password,				presence: true,
										length: { minimum: 6 }
										
end
