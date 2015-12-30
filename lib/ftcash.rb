class Ftcash
	include HTTParty
	require 'openssl'

	debug_output $stdout

	base_uri "https://www.ftcash.com"

	def self.make_payment(delivery)
		user = delivery.user
		amount = delivery.get_total_amount

		@query = {
			"email"		=> user.email,
			"amount"	=> amount,
			"cell"		=> user.phone_number,
			"orderid"	=> delivery.booking_no,
			"mid"		=> ENV['FTCASH_MID'],
			"name"		=> user.name,
			"checksum"	=> Ftcash.get_checksum(amount, delivery.booking_no)
		}
		response = self.post("/app/temp/verifymerchant.php", body: @query, debug_output: $stdout)
		return "https://www.ftcash.com/app/fmc/pay?mid=#{ENV["FTCASH_MID"]}&orderid=#{delivery.booking_no}&amount=#{delivery.get_total_amount}&back_to=www.breadnpulp.com/users/#{delivery.user.id}"
	end

	private

		def Ftcash.get_checksum(amount, booking_no)
			full_string = "'" + amount.to_s + "''" + booking_no + "''" + ENV["FTCASH_MID"] + "'"
			OpenSSL::HMAC.hexdigest('sha256', ENV['FTCASH_SECRET'], full_string)
		end

end