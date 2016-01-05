class AddOtPsToAllUsers < ActiveRecord::Migration
  def change
  	User.all.each { |user| user.update_attribute(:otp_secret_key, ROTP::Base32.random_base32) }
  end
end
