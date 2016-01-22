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

class Rider < User

	default_scope { where(type: 'Rider') }

	def details
		RiderDetail.find_or_create_by(user_id: id)
	end

	def kitchen
		Kitchen.find details.kitchen_id || 1
	end
end
