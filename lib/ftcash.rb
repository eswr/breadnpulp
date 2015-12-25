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
			"mid"		=> Ftcash.MID,
			"name"		=> user.name,
			"checksum"	=> Ftcash.get_checksum(amount, delivery.booking_no)
		}
		response = self.post("/app/temp/verifymerchant.php", body: @query, debug_output: $stdout)
		puts response.body
	end

	private

		def Ftcash.MID
			"6104"
		end

		def Ftcash.SECRET
			"EWd3O1QtPM0fDU6l"
		end

		def Ftcash.get_checksum(amount, booking_no)
			full_string = "'" + amount.to_s + "''" + booking_no + "''" + Ftcash.MID + "'"
			OpenSSL::HMAC.hexdigest('sha256', full_string, Ftcash.SECRET)
		end

end