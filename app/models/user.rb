# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  name              :string
#  email             :string
#  phone_number      :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  password_digest   :string
#  remember_digest   :string
#  admin             :boolean          default(FALSE)
#  activation_digest :string
#  activated         :boolean          default(FALSE)
#  activated_at      :datetime
#  reset_digest      :string
#  reset_sent_at     :datetime
#  source            :string
#  deliveries_count  :integer          default(0)
#  otp_secret_key    :string
#  provider          :string
#  uid               :string
#  oauth_token       :string
#  oauth_expires_at  :datetime
#  type              :string
#

class User < ActiveRecord::Base
  rolify
  attr_accessor :remember_token, :activation_token, :reset_token

	before_save 						:downcase_email
	before_create						:create_activation_digest
	after_create						:create_food_alert

	validates 	:name, 					presence: true,
										length: { maximum: 50 }

	VALID_PHONE_NUMBER_REGEX = /\A[1-9]{1}\d{9}\z/
	validates 	:phone_number, 			presence: true,
										length: { is: 10 },
										format: { with: VALID_PHONE_NUMBER_REGEX },
										uniqueness: true
	
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates 	:email, 				presence: true,
										length: { maximum: 255 },
										format: { with: VALID_EMAIL_REGEX },
										uniqueness: { case_sensitive: false }

	has_secure_password
	has_one_time_password length: 4

	validates 	:password,				presence: true,
										length: { minimum: 6 },
										allow_nil: true

	has_many	:addresses
	has_many	:deliveries
	has_many	:subscriptions

	has_one		:food_alert

  	# accepts_nested_attributes_for :addresses, reject_if: lambda { |attributes| attributes[:full_address].nil? }
	# Returns the hash digest of the given string.
	def User.digest(string)
	  cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
	                                                  BCrypt::Engine.cost
	  BCrypt::Password.create(string, cost: cost)
	end

	# Returns a random token.
  	def User.new_token
    	SecureRandom.urlsafe_base64
  	end

  	# Remembers a user in the database for use in persistent sessions.
  	def remember
    	self.remember_token = User.new_token
    	update_attribute(:remember_digest, User.digest(remember_token))
  	end

  	# Forgets a user.
	def forget
	    update_attribute(:remember_digest, nil)
	end

  	# Returns true if the given token matches the digest.
  	def authenticated?(attribute, token)
  		digest = send("#{attribute}_digest")
    	return false if digest.nil?
    	BCrypt::Password.new(digest).is_password?(token)
  	end

  	# Activates an account.
  	def activate
	    update_attribute(:activated,    true)
	    update_attribute(:activated_at, Time.zone.now)
  	end

	# Sends activation email.
  	def send_activation_email
	    UserMailer.account_activation(self).deliver_now
  	end

  	def send_otp
  		Msg91.delay.send_sms(phone_number, "Login OTP: #{self.otp_code} and start your day in a healthy way!")
  	end

  	# Sets the password reset attributes.
	def create_reset_digest
		self.reset_token = User.new_token
		update_attribute(:reset_digest,  User.digest(reset_token))
		update_attribute(:reset_sent_at, Time.zone.now)
	end

	# Sends password reset email.
	def send_password_reset_email
		UserMailer.password_reset(self).deliver_now
	end

	# Returns true if a password reset has expired.
	def password_reset_expired?
		reset_sent_at < 2.hours.ago
	end

	def create_food_alert
    	self.build_food_alert.save
    end

    def User.get_from_ids(ids)
    	users = []
    	ids.each do |id|
    		users << User.find(id)
    	end
    	users
    end

    def self.to_csv
    	CSV.generate do |csv|
    		csv << ["Id", "Name", "Phone Number", "Email", "No of orders"]
    		all.each do |user|
    			csv << [user.id, user.name, user.phone_number, user.email, user.deliveries_count]
    		end
    	end
    end

    def self.from_omniauth(auth)
    	user = where(provider: auth.provider, uid: auth.uid).first
		unless user
			# in that case you will find existing user doesn't connected to facebook
			# or create new one by email
			user = where(email: auth.info.email).first_or_initialize
			user.provider = auth.provider # and connect him to facebook here
			user.uid = auth.uid           # and here
			user.name ||= auth.info.name
			user.phone_number ||= User.get_next_dummy_phone_number
			user.oauth_token = auth.credentials.token
			user.oauth_expires_at = auth.credentials.token
			user.password = User.new_token
			user.activated = true
			# other user's data you want to update
			user.save!
    	end
    	user
    end

    def self.inheritance_column
		:no_such_column_because_we_dont_want_type_casting
	end

  	private

	  	# Converts email to all lower-case.
	    def downcase_email
	      self.email = email.downcase
	    end

	    # Creates and assigns the activation token and digest.
	    def create_activation_digest
	      self.activation_token  = User.new_token
	      self.activation_digest = User.digest(activation_token)
	    end

	    def accessible_attributes
	    	[name, phone_number]
		end

		def self.get_next_dummy_phone_number
			exp_id = User.last.id + 1
			id_length = exp_id.to_s.length
			return '1'*(10 - id_length) + exp_id.to_s
		end
end
